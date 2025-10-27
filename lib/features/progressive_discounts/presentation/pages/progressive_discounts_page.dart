// lib/features/progressive_discounts/presentation/pages/progressive_discounts_page.dart

import 'package:flutter/material.dart';
import 'package:projects_hub/core/di/injection_container.dart'; // Importa o get<T>()
import 'package:projects_hub/core/providers/viewmodel_provider.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/progressive_discounts_viewmodel.dart';

class ProgressiveDiscountsPage extends StatelessWidget {
  const ProgressiveDiscountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Prover o ViewModel
    return ViewModelProvider<ProgressiveDiscountsViewModel>(
      create: () =>
          get<ProgressiveDiscountsViewModel>(), // Obtém a instância do GetIt
      child: Scaffold(
        appBar: AppBar(title: const Text('Descontos Progressivos')),
        body: const ProgressiveDiscountsView(),
      ),
    );
  }
}

class ProgressiveDiscountsView extends StatefulWidget {
  const ProgressiveDiscountsView({super.key});

  @override
  State<ProgressiveDiscountsView> createState() =>
      _ProgressiveDiscountsViewState();
}

class _ProgressiveDiscountsViewState extends State<ProgressiveDiscountsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ViewModelProvider.of<ProgressiveDiscountsViewModel>(
        context,
      ).loadDiscountTables();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 3. Consumir o estado do ViewModel
    return Consumer<ProgressiveDiscountsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null) {
          return Center(child: Text('Erro: ${viewModel.errorMessage}'));
        }

        // Verifica se ambas as listas estão vazias
        if (viewModel.baseDiscountTable == null &&
            viewModel.customDiscountTables.isEmpty) {
          return const Center(
            child: Text('Nenhuma tabela de desconto encontrada.'),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Tabela Base'),
                  Tab(text: 'Tabelas Personalizadas'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Aba Tabela Base
                    _buildBaseTableTab(viewModel),
                    // Aba Tabelas Personalizadas
                    _buildCustomTablesTab(viewModel),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBaseTableTab(ProgressiveDiscountsViewModel viewModel) {
    if (viewModel.baseDiscountTable == null) {
      return const Center(child: Text('Nenhuma tabela base definida.'));
    }
    return ListView(
      children: [
        _DiscountTableItem(
          table: viewModel.baseDiscountTable!,
          viewModel: viewModel,
          isBaseTable: true,
        ),
      ],
    );
  }

  Widget _buildCustomTablesTab(ProgressiveDiscountsViewModel viewModel) {
    if (viewModel.customDiscountTables.isEmpty) {
      return const Center(
        child: Text('Nenhuma tabela personalizada encontrada.'),
      );
    }
    return ListView.builder(
      itemCount: viewModel.customDiscountTables.length,
      itemBuilder: (context, index) {
        final table = viewModel.customDiscountTables[index];
        return _DiscountTableItem(
          table: table,
          viewModel: viewModel,
          isBaseTable: false,
        );
      },
    );
  }
}

/// Widget para exibir um item da tabela de desconto com ações
class _DiscountTableItem extends StatelessWidget {
  final DiscountTableEntity table;
  final ProgressiveDiscountsViewModel viewModel;
  final bool isBaseTable;

  const _DiscountTableItem({
    required this.table,
    required this.viewModel,
    this.isBaseTable = false,
  });

  // Mostra um dialog para editar o nickname
  void _showEditNicknameDialog(BuildContext context) {
    final controller = TextEditingController(text: table.nickname);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Nome'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nickname'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                viewModel.updateNickname(table.id, controller.text);
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(table.nickname),
        subtitle: Text('ID: ${table.id}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditNicknameDialog(context);
                break;
              case 'clone':
                viewModel.cloneTable(table.id);
                break;
              case 'set_as_base':
                viewModel.setAsBase(table.id);
                break;
              case 'delete':
                viewModel.deleteTable(table.id);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Editar Nome')),
            const PopupMenuItem(value: 'clone', child: Text('Clonar')),
            if (!isBaseTable)
              const PopupMenuItem(
                value: 'set_as_base',
                child: Text('Definir como Base'),
              ),
            if (!isBaseTable)
              const PopupMenuItem(value: 'delete', child: Text('Excluir')),
          ],
        ),
      ),
    );
  }
}
