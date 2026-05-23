import 'dart:async';

import 'package:flutter/foundation.dart';

import '../db/app_database.dart';
import '../models/live_vehicle.dart';
import '../models/transport_route.dart';
import 'mock_transport_data.dart';

class TransportRepository {
  int _tick = 0;

  List<TransportRoute> getRoutes() => MockTransportData.routes;

  List<LiveVehicle> getLiveVehicles() {
    _tick++;
    return MockTransportData.vehiclesTick(_tick);
  }

  TransportRoute? findRouteById(int routeId) {
    try {
      return MockTransportData.routes.firstWhere((route) => route.id == routeId);
    } catch (_) {
      return null;
    }
  }

  Future<Set<int>> loadFavorites() async {
    try {
      final db = await AppDatabase.database();
      final rows = await db.query('favorites');
      return rows.map((e) => e['routeId'] as int).toSet();
    } catch (e) {
      debugPrint('Favorites load error: $e');
      return {};
    }
  }

  Future<void> toggleFavorite(int routeId, bool isFavorite) async {
    try {
      final db = await AppDatabase.database();
      if (isFavorite) {
        await db.delete(
          'favorites',
          where: 'routeId = ?',
          whereArgs: [routeId],
        );
      } else {
        await db.insert('favorites', {'routeId': routeId});
      }
    } catch (e) {
      debugPrint('Favorites toggle error: $e');
    }
  }

  Future<List<int>> loadHistory() async {
    try {
      final db = await AppDatabase.database();
      final rows = await db.query(
        'history',
        orderBy: 'id DESC',
        limit: 20,
      );
      return rows.map((e) => e['routeId'] as int).toList();
    } catch (e) {
      debugPrint('History load error: $e');
      return [];
    }
  }

  Future<void> addToHistory(int routeId) async {
    try {
      final db = await AppDatabase.database();
      await db.insert('history', {
        'routeId': routeId,
        'openedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('History add error: $e');
    }
  }

  Future<void> clearHistory() async {
    try {
      final db = await AppDatabase.database();
      await db.delete('history');
    } catch (e) {
      debugPrint('History clear error: $e');
    }
  }
}