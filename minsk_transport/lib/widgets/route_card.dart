import 'package:flutter/material.dart';

import '../models/transport_route.dart';

class RouteCard extends StatelessWidget {
  final TransportRoute route;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const RouteCard({
    super.key,
    required this.route,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(route.number),
        ),
        title: Text('${route.number} • ${route.title}'),
        subtitle: Text('${route.type.name} • ${route.travelMinutes} min'),
        trailing: IconButton(
          onPressed: onFavoriteToggle,
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.amber : null,
          ),
        ),
      ),
    );
  }
}