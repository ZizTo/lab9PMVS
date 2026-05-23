import '../models/live_vehicle.dart';
import '../models/route_stop.dart';
import '../models/transport_route.dart';
import '../models/transport_type.dart';

class MockTransportData {
  static List<TransportRoute> routes = [
    TransportRoute(
      id: 1,
      number: '1',
      title: 'ДС Веснянка - Вокзал',
      type: TransportType.bus,
      travelMinutes: 28,
      stops: const [
        RouteStop(name: 'ДС Веснянка', lat: 53.9265, lng: 27.4839),
        RouteStop(name: 'Романовская Слобода', lat: 53.9052, lng: 27.5470),
        RouteStop(name: 'Вокзал', lat: 53.8918, lng: 27.5507),
      ],
    ),
    TransportRoute(
      id: 2,
      number: '10',
      title: 'Серебрянка - Немига',
      type: TransportType.trolleybus,
      travelMinutes: 24,
      stops: const [
        RouteStop(name: 'Серебрянка', lat: 53.8612, lng: 27.6128),
        RouteStop(name: 'Ленина', lat: 53.8961, lng: 27.5618),
        RouteStop(name: 'Немига', lat: 53.9040, lng: 27.5512),
      ],
    ),
    TransportRoute(
      id: 3,
      number: '6',
      title: 'Зелёный Луг - Площадь Якуба Коласа',
      type: TransportType.tram,
      travelMinutes: 19,
      stops: const [
        RouteStop(name: 'Зелёный Луг', lat: 53.9488, lng: 27.6135),
        RouteStop(name: 'Комаровка', lat: 53.9211, lng: 27.5822),
        RouteStop(name: 'Пл. Якуба Коласа', lat: 53.9168, lng: 27.5850),
      ],
    ),
    TransportRoute(
      id: 4,
      number: '50c',
      title: 'Сухарево-3 - Вокзал',
      type: TransportType.bus,
      travelMinutes: 30,
      stops: const [
        RouteStop(name: 'Сухаревская', lat: 53.882233, lng: 27.440702),
        RouteStop(name: 'Максима Горецкого', lat: 53.884063, lng: 27.448302),
        RouteStop(name: 'Железнодорожная', lat: 53.870156, lng: 27.495435),
        RouteStop(name: 'Товарная', lat: 53.884168, lng: 27.535592),
        RouteStop(name: 'Площадь Независимости', lat: 53.894920, lng: 27.548110),
      ],
    ),
  ];

  static List<LiveVehicle> vehiclesTick(int tick) => [
    _createVehicle(1, routes[0], tick, 'Bus 1A', 0),
    _createVehicle(2, routes[1], tick, 'Trolley 10', 9),
    _createVehicle(3, routes[2], tick, 'Tram 6', 14),
    _createVehicle(4, routes[3], tick, 'Bus 50C', 20),
  ];

  static LiveVehicle _createVehicle(
      int id,
      TransportRoute route,
      int tick,
      String label,
      int tickOffset,
      ) {
    final stops = route.stops;

    final effectiveTick = tick + tickOffset;
    const ticksPerSegment = 15;
    final totalSegments = stops.length - 1;

    final cycleLength = totalSegments * 2 * ticksPerSegment;
    final cycleTick = effectiveTick % cycleLength;

    final isForward = cycleTick < (totalSegments * ticksPerSegment);
    final directionTick = isForward ? cycleTick : cycleLength - cycleTick - 1;

    final segmentIndex = directionTick ~/ ticksPerSegment;
    final progress = (directionTick % ticksPerSegment) / ticksPerSegment;

    final startStop = stops[segmentIndex];
    final endStop = stops[segmentIndex + 1];

    final currentLat = startStop.lat + (endStop.lat - startStop.lat) * progress;
    final currentLng = startStop.lng + (endStop.lng - startStop.lng) * progress;

    return LiveVehicle(
      id: id,
      routeId: route.id,
      label: label,
      type: route.type,
      lat: currentLat,
      lng: currentLng,
    );
  }
}