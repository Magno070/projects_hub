import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:projects_hub/features/home/presentation/pages/home_page.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/pages/progressive_discounts_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String progressiveDiscounts = '/progressive-discounts';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),

      GoRoute(
        path: AppRoutes.progressiveDiscounts,
        builder: (BuildContext context, GoRouterState state) {
          return const ProgressiveDiscountsPage();
        },
      ),
    ],
  );
}
