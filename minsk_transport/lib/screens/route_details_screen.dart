import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/transport_provider.dart';

class RouteDetailsScreen extends ConsumerWidget {
  final int routeId;

  const RouteDetailsScreen({
    super.key,
    required this.routeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final transportState = ref.watch(transportProvider);
    final notifier = ref.read(transportProvider.notifier);
    final route = notifier.getRouteById(routeId);

    if (route == null || route.id == -1) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.routeDetails),
        ),
        body: Center(
          child: Text(l10n.noData),
        ),
      );
    }

    final currentVehicle = transportState.vehicles
        .where((vehicle) => vehicle.routeId == route.id)
        .cast<dynamic>()
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.routeNumber(route.number)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          final infoCard = Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('${l10n.type}: ${route.type.name}'),
                  const SizedBox(height: 8),
                  Text(l10n.travelTime(route.travelMinutes)),
                  const SizedBox(height: 8),
                  Text('${l10n.stops}: ${route.stops.length}'),
                  const SizedBox(height: 8),
                  Text(
                    currentVehicle != null
                        ? '${l10n.liveVehicle}: ${currentVehicle.label}'
                        : l10n.noLiveVehicle,
                  ),
                ],
              ),
            ),
          );

          final stopsCard = Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.stops,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: route.stops.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final stop = route.stops[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(stop.name),
                          subtitle: Text(
                            'lat: ${stop.lat.toStringAsFixed(4)}, lng: ${stop.lng.toStringAsFixed(4)}',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );

          if (isDesktop) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: double.infinity,
                      child: infoCard,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      height: double.infinity,
                      child: stopsCard,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                infoCard,
                const SizedBox(height: 12),
                Expanded(child: stopsCard),
              ],
            ),
          );
        },
      ),
    );
  }
}