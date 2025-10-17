import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/pages/discounts_home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DiscountsHome());
  }
}
