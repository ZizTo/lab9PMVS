import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/transport_repository.dart';
import '../models/live_vehicle.dart';
import '../models/transport_route.dart';
import '../models/transport_type.dart';

class TransportState {
  final List<TransportRoute> routes;
  final List<LiveVehicle> vehicles;
  final Set<int> favoriteIds;
  final List<int> historyRouteIds;
  final TransportType? filter;
  final bool isLoading;
  final String? errorMessage;

  const TransportState({
    required this.routes,
    required this.vehicles,
    required this.favoriteIds,
    required this.historyRouteIds,
    required this.filter,
    required this.isLoading,
    required this.errorMessage,
  });

  factory TransportState.initial() {
    return const TransportState(
      routes: [],
      vehicles: [],
      favoriteIds: {},
      historyRouteIds: [],
      filter: null,
      isLoading: false,
      errorMessage: null,
    );
  }

  TransportState copyWith({
    List<TransportRoute>? routes,
    List<LiveVehicle>? vehicles,
    Set<int>? favoriteIds,
    List<int>? historyRouteIds,
    TransportType? filter,
    bool clearFilter = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TransportState(
      routes: routes ?? this.routes,
      vehicles: vehicles ?? this.vehicles,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      historyRouteIds: historyRouteIds ?? this.historyRouteIds,
      filter: clearFilter ? null : (filter ?? this.filter),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage,
    );
  }

  List<TransportRoute> get filteredRoutes {
    if (filter == null) return routes;
    return routes.where((route) => route.type == filter).toList();
  }

  List<TransportRoute> get favoriteRoutes {
    return routes.where((route) => favoriteIds.contains(route.id)).toList();
  }

  List<TransportRoute> get historyRoutes {
    return historyRouteIds
        .map((id) {
      try {
        return routes.firstWhere((route) => route.id == id);
      } catch (_) {
        return null;
      }
    })
        .whereType<TransportRoute>()
        .toList();
  }
}

class TransportNotifier extends StateNotifier<TransportState> {
  TransportNotifier({required this.repository}) : super(TransportState.initial());

  final TransportRepository repository;
  Timer? _timer;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final routes = repository.getRoutes();
      final favorites = await repository.loadFavorites();
      final history = await repository.loadHistory();
      final vehicles = repository.getLiveVehicles();

      state = state.copyWith(
        routes: routes,
        favoriteIds: favorites,
        historyRouteIds: history,
        vehicles: vehicles,
        isLoading: false,
      );

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 2), (_) {
        refreshVehicles();
      });
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Load error: $e',
      );
    }
  }

  void refreshVehicles() {
    try {
      final vehicles = repository.getLiveVehicles();
      state = state.copyWith(vehicles: vehicles);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Vehicles refresh error: $e');
    }
  }

  void setFilter(TransportType? type) {
    if (type == null) {
      state = state.copyWith(clearFilter: true);
      return;
    }
    state = state.copyWith(filter: type);
  }

  Future<void> toggleFavorite(int routeId) async {
    final isFavorite = state.favoriteIds.contains(routeId);

    await repository.toggleFavorite(routeId, isFavorite);

    final updated = Set<int>.from(state.favoriteIds);
    if (isFavorite) {
      updated.remove(routeId);
    } else {
      updated.add(routeId);
    }

    state = state.copyWith(favoriteIds: updated);
  }

  Future<void> openRoute(int routeId) async {
    await repository.addToHistory(routeId);

    final updated = List<int>.from(state.historyRouteIds);
    updated.remove(routeId);
    updated.insert(0, routeId);

    state = state.copyWith(historyRouteIds: updated);
  }

  Future<void> clearHistory() async {
    await repository.clearHistory();
    state = state.copyWith(historyRouteIds: []);
  }

  TransportRoute? getRouteById(int routeId) {
    try {
      return state.routes.firstWhere((route) => route.id == routeId);
    } catch (_) {
      return repository.findRouteById(routeId);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final transportRepositoryProvider = Provider<TransportRepository>((ref) {
  return TransportRepository();
});

final transportProvider =
StateNotifierProvider<TransportNotifier, TransportState>((ref) {
  final repository = ref.watch(transportRepositoryProvider);
  return TransportNotifier(repository: repository);
});