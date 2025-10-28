import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/progressive_discounts_viewmodel.dart';

class DiscountTableItem extends StatelessWidget {
  final DiscountTableEntity table;
  final ProgressiveDiscountsViewModel viewModel;
  final bool isBaseTable;

  const DiscountTableItem({
    super.key,
    required this.table,
    required this.viewModel,
    this.isBaseTable = false,
  });

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
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(table.nickname),
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
        children: [_buildRangesList(context, table.ranges)],
      ),
    );
  }

  Widget _buildRangesList(
    BuildContext context,
    List<DiscountTableRangeEntity> ranges,
  ) {
    // Garante que os ranges estejam ordenados pelo início
    final sortedRanges = List<DiscountTableRangeEntity>.from(ranges)
      ..sort((a, b) => a.initialRange.compareTo(b.initialRange));

    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com informações da tabela
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.table_chart,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tipo de Desconto',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        table.discountType,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '${ranges.length} faixas',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          // Título das faixas
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Theme.of(context).colorScheme.secondary,
                size: 18.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Faixas de Desconto',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          ...sortedRanges.asMap().entries.map((entry) {
            final index = entry.key;
            final range = entry.value;
            final isLast = index == sortedRanges.length - 1;

            return Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 2.0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Ícone de faixa
                    Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                        color: _getRangeColor(context, range.discount),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Icon(
                        Icons.percent,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),

                    const SizedBox(width: 12.0),

                    // Informações da faixa
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${range.initialRange} - ${range.finalRange} clientes',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                          Text(
                            'Faixa ${index + 1}',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),

                    // Valor do desconto
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: _getRangeColor(
                          context,
                          range.discount,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: _getRangeColor(
                            context,
                            range.discount,
                          ).withOpacity(0.3),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        '${range.discount.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getRangeColor(context, range.discount),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          // Resumo das faixas
          if (ranges.isNotEmpty) ...[
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.secondaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 16.0,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Desconto varia de ${sortedRanges.first.discount.toStringAsFixed(1)}% a ${sortedRanges.last.discount.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Método auxiliar para determinar a cor baseada no valor do desconto
  Color _getRangeColor(BuildContext context, double discount) {
    if (discount >= 20.0) {
      return Colors.green.shade600;
    } else if (discount >= 10.0) {
      return Colors.orange.shade600;
    } else if (discount >= 5.0) {
      return Colors.amber.shade600;
    } else {
      return Colors.blue.shade600;
    }
  }
}
