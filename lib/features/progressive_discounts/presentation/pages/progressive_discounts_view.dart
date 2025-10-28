import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/progressive_discounts_viewmodel.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/discount_table_item.dart';
import 'package:provider/provider.dart';

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
      Provider.of<ProgressiveDiscountsViewModel>(
        context,
        listen: false,
      ).loadDiscountTables();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tabelas de Descontos')),
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(child: Text('Tabela Base', style: TextStyle(fontSize: 18))),
                Tab(
                  child: Text(
                    'Tabelas Personalizadas',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Consumer<ProgressiveDiscountsViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.errorMessage != null) {
                    return Center(
                      child: Text('Erro: ${viewModel.errorMessage}'),
                    );
                  }

                  if (viewModel.baseDiscountTable == null &&
                      viewModel.customDiscountTables.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma tabela de desconto encontrada.'),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: TabBarView(
                      children: [
                        _buildBaseTableTab(viewModel),
                        _buildCustomTablesTab(viewModel),
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

  Widget _buildBaseTableTab(ProgressiveDiscountsViewModel viewModel) {
    if (viewModel.baseDiscountTable == null) {
      return const Center(child: Text('Nenhuma tabela base definida.'));
    }
    return ListView(
      children: [
        DiscountTableItem(
          table: viewModel.baseDiscountTable!,
          viewModel: viewModel,
          isBaseTable: true,
          isSelected:
              viewModel.selectedTableId == viewModel.baseDiscountTable!.id,
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
        return DiscountTableItem(
          table: table,
          viewModel: viewModel,
          isBaseTable: false,
          isSelected: viewModel.selectedTableId == table.id,
        );
      },
    );
  }
}
