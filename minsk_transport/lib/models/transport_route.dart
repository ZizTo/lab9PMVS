import 'route_stop.dart';
import 'transport_type.dart';

class TransportRoute {
  final int id;
  final String number;
  final String title;
  final TransportType type;
  final int travelMinutes;
  final List<RouteStop> stops;

  const TransportRoute({
    required this.id,
    required this.number,
    required this.title,
    required this.type,
    required this.travelMinutes,
    required this.stops,
  });

  const TransportRoute.empty()
      : id = -1,
        number = '',
        title = '',
        type = TransportType.bus,
        travelMinutes = 0,
        stops = const [];
}