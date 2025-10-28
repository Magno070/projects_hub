import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:projects_hub/core/di/injection_container.dart';
import 'package:projects_hub/features/home/presentation/pages/home_page.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/pages/progressive_discounts_page.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/pages/progressive_discounts_view.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/progressive_discounts_viewmodel.dart';

class AppRoutes {
  static const String home = '/';
  static const String progressiveDiscounts = '/progressive-discounts';
  static const String progressiveDiscountsViewTables =
      '$progressiveDiscounts/view-tables';
  static const String progressiveDiscountsViewPartners =
      '$progressiveDiscounts/view-partners';
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
        routes: [
          GoRoute(
            path: 'view-tables',
            builder: (BuildContext context, GoRouterState state) {
              return ChangeNotifierProvider<ProgressiveDiscountsViewModel>(
                create: (context) => get<ProgressiveDiscountsViewModel>(),
                child: const ProgressiveDiscountsView(),
              );
            },
          ),
          GoRoute(
            path: 'view-partners',
            builder: (BuildContext context, GoRouterState state) {
              return const Placeholder();
            },
          ),
        ],
        builder: (BuildContext context, GoRouterState state) {
          return const ProgressiveDiscountsPage();
        },
      ),
    ],
  );
}
