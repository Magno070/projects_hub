import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projects_hub/core/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hub de Projetos')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Bem-vindo!', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text(
            'Este app contém vários projetos pequenos. Selecione um abaixo para começar.',
          ),
          const SizedBox(height: 24),

          Card(
            child: ListTile(
              title: const Text('Calculador de Descontos Progressivos'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.push(AppRoutes.progressiveDiscounts);
              },
            ),
          ),
        ],
      ),
    );
  }
}
