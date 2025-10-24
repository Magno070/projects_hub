import 'package:flutter/material.dart';
import 'package:projects_hub/core/di/injection_container.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/pages/discounts_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configura as dependências
  await configureDependencies();
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DiscountsHome());
  }
}
