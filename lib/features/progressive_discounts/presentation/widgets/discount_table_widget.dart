import 'package:flutter/material.dart';
import 'package:projects_hub/core/providers/viewmodel_provider.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/discounts_table_viewmodel.dart';

/// Widget que exibe a tabela de descontos usando MVVM
class DiscountTableWidget extends StatelessWidget {
  const DiscountTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelConsumer<DiscountsTableViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.hasData) {
          return const Center(
            child: Text('Nenhuma tabela carregada'),
          );
        }

        final table = viewModel.discountTable!;
        
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho da tabela
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        table.nickname,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(table.discountType),
                      backgroundColor: Colors.blue[100],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tabela de faixas
                if (table.discountRanges.isNotEmpty) ...[
                  const Text(
                    'Faixas de Desconto:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...table.discountRanges.asMap().entries.map((entry) {
                    final index = entry.key;
                    final range = entry.value;
                    return _buildRangeRow(context, viewModel, index, range);
                  }),
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total de Descontos:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'R\$ ${viewModel.calculateTotalDiscounts().toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const Center(
                    child: Text(
                      'Nenhuma faixa de desconto definida',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRangeRow(
    BuildContext context,
    DiscountsTableViewModel viewModel,
    int index,
    DiscountTableRangeEntity range,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('${range.initialRange} - ${range.finalRange}'),
          ),
          Expanded(
            flex: 2,
            child: Text('${range.discount}%'),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'R\$ ${viewModel.calculateTotalForRange(range).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => viewModel.removeDiscountRange(index),
              tooltip: 'Remover faixa',
            ),
          ),
        ],
      ),
    );
  }
}