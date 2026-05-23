import 'package:flutter_test/flutter_test.dart';

import 'package:minsk_transport/data/transport_repository.dart';
import 'package:minsk_transport/models/transport_type.dart';
import 'package:minsk_transport/providers/transport_provider.dart';

void main() {
  late TransportNotifier notifier;

  setUp(() {
    notifier = TransportNotifier(
      repository: TransportRepository(),
    );
  });

  test('initial state is empty', () {
    expect(notifier.state.routes, isEmpty);
    expect(notifier.state.vehicles, isEmpty);
    expect(notifier.state.favoriteIds, isEmpty);
    expect(notifier.state.historyRouteIds, isEmpty);
    expect(notifier.state.filter, isNull);
  });

  test('load fills routes and vehicles', () async {
    await notifier.load();

    expect(notifier.state.routes, isNotEmpty);
    expect(notifier.state.vehicles, isNotEmpty);
  });

  test('setFilter applies bus filter', () async {
    await notifier.load();
    notifier.setFilter(TransportType.bus);

    expect(notifier.state.filter, TransportType.bus);
    expect(
      notifier.state.filteredRoutes.every((route) => route.type == TransportType.bus),
      true,
    );
  });

  test('setFilter null clears filter', () async {
    await notifier.load();
    notifier.setFilter(TransportType.tram);
    notifier.setFilter(null);

    expect(notifier.state.filter, isNull);
  });

  test('getRouteById returns existing route', () async {
    await notifier.load();
    final route = notifier.getRouteById(1);

    expect(route, isNotNull);
    expect(route!.id, 1);
  });
}