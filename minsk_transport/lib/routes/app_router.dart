import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/route_details_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: authState.isLoggedIn ? '/' : '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/details/:id',
        name: 'details',
        builder: (context, state) {
          final idParam = state.pathParameters['id'] ?? '';
          final routeId = int.tryParse(idParam) ?? -1;
          return RouteDetailsScreen(routeId: routeId);
        },
      ),
    ],
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';

      if (!authState.isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (authState.isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
  );
});