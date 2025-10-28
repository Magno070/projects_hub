import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:projects_hub/core/di/injection_container.dart';
import 'package:projects_hub/core/router/app_router.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/progressive_discounts_viewmodel.dart';

class ProgressiveDiscountsPage extends StatelessWidget {
  const ProgressiveDiscountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProgressiveDiscountsViewModel>(
      create: (context) => get<ProgressiveDiscountsViewModel>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Descontos Progressivos')),
        body: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  context.push(AppRoutes.progressiveDiscountsViewTables);
                },
                child: const Text('Visualizar Tabelas'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  context.push(AppRoutes.progressiveDiscountsViewPartners);
                },
                child: const Text('Tabelas Personalizadas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
