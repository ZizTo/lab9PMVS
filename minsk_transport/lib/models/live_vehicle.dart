import 'transport_type.dart';

class LiveVehicle {
  final int id;
  final int routeId;
  final String label;
  final TransportType type;
  final double lat;
  final double lng;

  const LiveVehicle({
    required this.id,
    required this.routeId,
    required this.label,
    required this.type,
    required this.lat,
    required this.lng,
  });
}