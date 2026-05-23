enum TransportType {
  bus,
  trolleybus,
  tram,
}

extension TransportTypeX on TransportType {
  String get name {
    switch (this) {
      case TransportType.bus:
        return 'Bus';
      case TransportType.trolleybus:
        return 'Trolleybus';
      case TransportType.tram:
        return 'Tram';
    }
  }

  String get localizedKey {
    switch (this) {
      case TransportType.bus:
        return 'bus';
      case TransportType.trolleybus:
        return 'trolleybus';
      case TransportType.tram:
        return 'tram';
    }
  }
}