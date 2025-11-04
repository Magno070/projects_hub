import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';

class RangesListWidget extends StatelessWidget {
  final List<DiscountTableRangeEntity> ranges;

  const RangesListWidget({super.key, required this.ranges});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28.0),
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

          ...ranges.asMap().entries.map((entry) {
            final index = entry.key;
            final range = entry.value;
            final isLast = index == ranges.length - 1;

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
                    const SizedBox(width: 12.0),
                    // Informações da faixa
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${range.initialRange} - ${range.finalRange} clientes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
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
          }),

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
                      'Desconto varia de ${ranges.first.discount.toStringAsFixed(1)}% a ${ranges.last.discount.toStringAsFixed(1)}%',
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
