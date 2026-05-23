import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../l10n/app_localizations.dart';
import '../models/transport_type.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/transport_provider.dart';
import '../widgets/route_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(transportProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transportProvider);
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;
    final isTablet = width >= 700 && width < 900;

    final pages = [
      _buildRoutesPage(context, state, l10n, isDesktop),
      _buildFavoritesPage(context, state, l10n),
      _buildHistoryPage(context, state, l10n),
      _buildSettingsPage(context, l10n),
    ];

    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: const Icon(Icons.route),
        label: l10n.routes,
      ),
      NavigationDestination(
        icon: const Icon(Icons.star),
        label: l10n.favorites,
      ),
      NavigationDestination(
        icon: const Icon(Icons.history),
        label: l10n.history,
      ),
      NavigationDestination(
        icon: const Icon(Icons.settings),
        label: l10n.settings,
      ),
    ];

    final railDestinations = <NavigationRailDestination>[
      NavigationRailDestination(
        icon: const Icon(Icons.route),
        label: Text(l10n.routes),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.star),
        label: Text(l10n.favorites),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.history),
        label: Text(l10n.history),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.settings),
        label: Text(l10n.settings),
      ),
    ];

    if (isDesktop) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: [
            IconButton(
              tooltip: l10n.logout,
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                setState(() => currentIndex = index);
              },
              labelType: NavigationRailLabelType.all,
              destinations: railDestinations,
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: pages[currentIndex],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          if (isTablet)
            IconButton(
              tooltip: l10n.logout,
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      endDrawer: isTablet ? _buildAdaptiveDrawer(context, l10n) : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[currentIndex],
      ),
      bottomNavigationBar: !isTablet
          ? NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
        destinations: destinations,
      )
          : null,
    );
  }

  Widget _buildAdaptiveDrawer(BuildContext context, AppLocalizations l10n) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.route),
            title: Text(l10n.routes),
            selected: currentIndex == 0,
            onTap: () {
              setState(() => currentIndex = 0);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: Text(l10n.favorites),
            selected: currentIndex == 1,
            onTap: () {
              setState(() => currentIndex = 1);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(l10n.history),
            selected: currentIndex == 2,
            onTap: () {
              setState(() => currentIndex = 2);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.settings),
            selected: currentIndex == 3,
            onTap: () {
              setState(() => currentIndex = 3);
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.logout),
            onTap: () async {
              Navigator.of(context).pop();
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoutesPage(
      BuildContext context,
      TransportState state,
      AppLocalizations l10n,
      bool isDesktop,
      ) {
    final notifier = ref.read(transportProvider.notifier);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!));
    }

    final listView = ListView.builder(
      itemCount: state.filteredRoutes.length,
      itemBuilder: (context, index) {
        final route = state.filteredRoutes[index];
        return RouteCard(
          route: route,
          isFavorite: state.favoriteIds.contains(route.id),
          onFavoriteToggle: () => notifier.toggleFavorite(route.id),
          onTap: () async {
            await notifier.openRoute(route.id);
            if (!context.mounted) return;
            context.push('/details/${route.id}');
          },
        );
      },
    );

    final mapWidget = SizedBox(
      height: isDesktop ? double.infinity : 260,
      child: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(53.9, 27.5667),
          initialZoom: 11.5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.zizto.task4_minsk_transport',
          ),
          MarkerLayer(
            markers: state.vehicles
                .map(
                  (v) => Marker(
                point: LatLng(v.lat, v.lng),
                width: 90,
                height: 70,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.directions_transit,
                      color: Colors.red,
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        v.label,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );

    final filters = Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilterChip(
            label: Text(l10n.all),
            selected: state.filter == null,
            onSelected: (_) => notifier.setFilter(null),
          ),
          FilterChip(
            label: Text(l10n.bus),
            selected: state.filter == TransportType.bus,
            onSelected: (_) => notifier.setFilter(TransportType.bus),
          ),
          FilterChip(
            label: Text(l10n.trolleybus),
            selected: state.filter == TransportType.trolleybus,
            onSelected: (_) => notifier.setFilter(TransportType.trolleybus),
          ),
          FilterChip(
            label: Text(l10n.tram),
            selected: state.filter == TransportType.tram,
            onSelected: (_) => notifier.setFilter(TransportType.tram),
          ),
        ],
      ),
    );

    if (isDesktop) {
      return Padding(
        key: const ValueKey('routes'),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: mapWidget,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  filters,
                  Expanded(child: listView),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      key: const ValueKey('routes'),
      children: [
        mapWidget,
        filters,
        Expanded(child: listView),
      ],
    );
  }

  Widget _buildFavoritesPage(
      BuildContext context,
      TransportState state,
      AppLocalizations l10n,
      ) {
    final notifier = ref.read(transportProvider.notifier);

    return state.favoriteRoutes.isEmpty
        ? Center(
      key: const ValueKey('favorites'),
      child: Text(l10n.noData),
    )
        : ListView(
      key: const ValueKey('favorites'),
      children: state.favoriteRoutes
          .map(
            (route) => RouteCard(
          route: route,
          isFavorite: true,
          onFavoriteToggle: () => notifier.toggleFavorite(route.id),
          onTap: () async {
            await notifier.openRoute(route.id);
            if (!context.mounted) return;
            context.push('/details/${route.id}');
          },
        ),
      )
          .toList(),
    );
  }

  Widget _buildHistoryPage(
      BuildContext context,
      TransportState state,
      AppLocalizations l10n,
      ) {
    final notifier = ref.read(transportProvider.notifier);

    return Scaffold(
      key: const ValueKey('history'),
      body: state.historyRoutes.isEmpty
          ? Center(child: Text(l10n.noData))
          : ListView(
        children: state.historyRoutes
            .map(
              (route) => ListTile(
            leading: const Icon(Icons.history),
            title: Text('${route.number} • ${route.title}'),
            subtitle: Text('${route.type.name} • ${route.travelMinutes} min'),
            onTap: () {
              context.push('/details/${route.id}');
            },
          ),
        )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: notifier.clearHistory,
        label: Text(l10n.clearHistory),
        icon: const Icon(Icons.delete_outline),
      ),
    );
  }

  Widget _buildSettingsPage(BuildContext context, AppLocalizations l10n) {
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authProvider);

    String themeLabel;
    switch (themeMode) {
      case ThemeMode.light:
        themeLabel = l10n.lightTheme;
        break;
      case ThemeMode.dark:
        themeLabel = l10n.darkTheme;
        break;
      case ThemeMode.system:
        themeLabel = l10n.systemTheme;
        break;
    }

    return ListView(
      key: const ValueKey('settings'),
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(l10n.loggedInAs),
          subtitle: Text(authState.email ?? '-'),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l10n.language),
          subtitle: const Text('ru / en / be'),
        ),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(l10n.theme),
          subtitle: Text(themeLabel),
        ),
        const SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          segments: [
            ButtonSegment<ThemeMode>(
              value: ThemeMode.system,
              label: Text(l10n.systemTheme),
              icon: const Icon(Icons.brightness_auto),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.light,
              label: Text(l10n.lightTheme),
              icon: const Icon(Icons.light_mode),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.dark,
              label: Text(l10n.darkTheme),
              icon: const Icon(Icons.dark_mode),
            ),
          ],
          selected: {themeMode},
          onSelectionChanged: (selection) {
            ref
                .read(themeModeProvider.notifier)
                .setThemeMode(selection.first);
          },
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(l10n.version),
          subtitle: const Text('1.0.0'),
        ),
        ListTile(
          leading: Icon(
            kIsWeb ? Icons.web : Icons.devices,
          ),
          title: Text(l10n.platform),
          subtitle: Text(
            kIsWeb ? 'Web' : defaultTargetPlatform.name,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () async {
            await ref.read(authProvider.notifier).logout();
          },
          icon: const Icon(Icons.logout),
          label: Text(l10n.logout),
        ),
      ],
    );
  }
}