import 'package:flutter/material.dart';
import 'package:projects_hub/core/di/injection_container.dart';
import 'package:projects_hub/core/providers/viewmodel_provider.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/discounts_table_viewmodel.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/discounts_table_header.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/discount_table_widget.dart';

class DiscountsHome extends StatelessWidget {
  const DiscountsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DiscountsTableViewModel>(
      create: () => getIt<DiscountsTableViewModel>(),
      child: const _DiscountsHomeContent(),
    );
  }
}

class _DiscountsHomeContent extends StatelessWidget {
  const _DiscountsHomeContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descontos Progressivos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Simulação de descontos por faixa de clientes\nDefina o valor que uma determinada faixa de clientes receberá de desconto\nAo final será exibido a soma de todos as faixas descontadas",
              style: TextStyle(fontSize: 18),
            ),
            const DiscountsTableHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: ViewModelConsumer<DiscountsTableViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (viewModel.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Erro: ${viewModel.errorMessage}',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Recarregar dados
                              if (viewModel.currentTableId != null) {
                                viewModel.loadDiscountTable(viewModel.currentTableId!);
                              }
                            },
                            child: const Text('Tentar Novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!viewModel.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.table_chart_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhuma tabela de desconto carregada',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Carregar tabela de exemplo
                              viewModel.loadDiscountTable('example-table-id');
                            },
                            child: const Text('Carregar Tabela de Exemplo'),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const DiscountTableWidget(),
                        const SizedBox(height: 16),
                        // Botões de ação
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Adicionar nova faixa de desconto
                                _showAddRangeDialog(context, viewModel);
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Adicionar Faixa'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Editar nickname
                                _showEditNicknameDialog(context, viewModel);
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Editar Nome'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddRangeDialog(BuildContext context, DiscountsTableViewModel viewModel) {
    final initialRangeController = TextEditingController();
    final finalRangeController = TextEditingController();
    final discountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Faixa de Desconto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: initialRangeController,
              decoration: const InputDecoration(
                labelText: 'Faixa Inicial',
                hintText: 'Ex: 1',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: finalRangeController,
              decoration: const InputDecoration(
                labelText: 'Faixa Final',
                hintText: 'Ex: 10',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: discountController,
              decoration: const InputDecoration(
                labelText: 'Desconto (%)',
                hintText: 'Ex: 5.0',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final initialRange = int.tryParse(initialRangeController.text);
              final finalRange = int.tryParse(finalRangeController.text);
              final discount = double.tryParse(discountController.text);

              if (initialRange != null && finalRange != null && discount != null) {
                viewModel.addDiscountRange(
                  initialRange: initialRange,
                  finalRange: finalRange,
                  discount: discount,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _showEditNicknameDialog(BuildContext context, DiscountsTableViewModel viewModel) {
    final nicknameController = TextEditingController(text: viewModel.discountTable?.nickname ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Nome da Tabela'),
        content: TextField(
          controller: nicknameController,
          decoration: const InputDecoration(
            labelText: 'Nome da Tabela',
            hintText: 'Ex: Descontos VIP',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final newNickname = nicknameController.text.trim();
              if (newNickname.isNotEmpty) {
                viewModel.updateNickname(newNickname);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
