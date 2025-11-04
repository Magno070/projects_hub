import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_discount_log_entity.dart';

class DiscountsSummaryTableWidget extends StatelessWidget {
  final PartnerDiscountLogEntity log;
  final NumberFormat currencyFormat;
  const DiscountsSummaryTableWidget({
    super.key,
    required this.log,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Preço Total (Bruto)',
            currencyFormat.format(log.totalPriceResult),
            Colors.grey.shade700,
            context,
            isLast: false,
          ),
          _buildSummaryRow(
            'Total de Desconto',
            '- ${currencyFormat.format(log.totalDiscountResult)}',
            Colors.red.shade700,
            context,
            isLast: false,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preço Final (Com Desconto)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  currencyFormat.format(log.totalPriceAfterDiscountResult),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    Color color,
    BuildContext context, {
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                ),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: color,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
