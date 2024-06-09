import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/shared_keys.dart';
import '../../dependency_injection.dart';
import '../../presentation/view/home_screen.dart';
import '../../presentation/view/login_screen.dart';
import '../../presentation/view/todo_details_screen.dart';
import 'routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final GoRouter allRoutes = GoRouter(
  initialLocation: preferences.getString(SharedKeys.accessToken) != null
      ? '/'
      : Routes.login.withSlash,
  navigatorKey: navigatorKey,
  // redirect: (context, state) =>

  routes: <RouteBase>[
    GoRoute(
      path: Routes.login.withSlash,
      name: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
        path: "/",
        name: Routes.homeScreen,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: "${Routes.taskDetails}/:id",
            name: Routes.taskDetails,
            builder: (context, state) {
              final id = state.pathParameters['id'] as String;
              return TodoDetailsScreen(id: int.parse(id));
            },
          ),
        ]),
  ],
);
