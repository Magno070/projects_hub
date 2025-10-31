// lib/features/progressive_discounts/presentation/widgets/partner_discount_log_itemd.dart

import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_discount_log_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/partners_viewmodel.dart';
import 'package:intl/intl.dart';

class PartnerLogItem extends StatefulWidget {
  final PartnersViewModel viewModel;
  final PartnerDiscountLogEntity log;

  const PartnerLogItem({super.key, required this.viewModel, required this.log});

  @override
  State<PartnerLogItem> createState() => _PartnerLogItemState();
}

class _PartnerLogItemState extends State<PartnerLogItem> {
  // Inicialização dos formatadores (requer intl)
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.viewModel.selectedLogId == widget.log.id;

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'Cálculo em ${dateFormat.format(widget.log.calculationDate)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Final: ${currencyFormat.format(widget.log.totalPriceAfterDiscountResult)} | Desconto: ${currencyFormat.format(widget.log.totalDiscountResult)}',
            ),
            trailing: Icon(
              isSelected ? Icons.expand_less : Icons.expand_more,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              widget.viewModel.selectLog(widget.log.id);
            },
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: isSelected
                ? _buildLogDetails(context, widget.log)
                : const SizedBox.shrink(),
            crossFadeState: isSelected
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildLogDetails(BuildContext context, PartnerDiscountLogEntity log) {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
          Text(
            'Informações do Snapshot:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          _buildInfoRow(
            'Qtd. Clientes do Parceiro (Stamp):',
            log.partnerClientsAmountStamp.toString(),
          ),
          _buildInfoRow(
            'Preço Diário do Parceiro (Stamp):',
            currencyFormat.format(log.partnerDailyPriceStamp),
          ),
          _buildInfoRow(
            'Tabela de Desconto ID:',
            log.discountTableId,
            isId: true,
          ),
          const Divider(height: 20),
          Text(
            'Detalhes do Cálculo por Faixa:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          ...log.details.map((detail) => _buildDetailItem(context, detail)),
          const Divider(height: 20),
          _buildFinalResultRow(
            'Preço Total (Bruto):',
            currencyFormat.format(log.totalPriceResult),
            Colors.grey.shade700,
          ),
          _buildFinalResultRow(
            'Total Desconto:',
            '- ${currencyFormat.format(log.totalDiscountResult)}',
            Colors.red,
          ),
          _buildFinalResultRow(
            'Preço Final:',
            currencyFormat.format(log.totalPriceAfterDiscountResult),
            Theme.of(context).primaryColor,
            isFinal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isId = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: isId ? 'monospace' : null,
                fontSize: isId ? 12 : 13,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalResultRow(
    String label,
    String value,
    Color color, {
    bool isFinal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isFinal ? FontWeight.bold : FontWeight.w600,
              fontSize: isFinal ? 16 : 14,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isFinal ? FontWeight.bold : FontWeight.w600,
              fontSize: isFinal ? 16 : 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    PartnerDiscountLogDetailsEntity detail,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.secondaryContainer.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.numbers,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Faixa ${detail.initialRange} - ${detail.finalRange}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '${detail.discount.toStringAsFixed(1)}% Desconto',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Clientes nesta faixa:',
              detail.rangeTotalClientsAmount.toString(),
            ),
            _buildDetailRow(
              'Preço Total (Faixa):',
              currencyFormat.format(detail.rangeTotalPrice),
            ),
            _buildDetailRow(
              'Desconto Aplicado (Faixa):',
              currencyFormat.format(detail.rangeTotalDiscount),
              isDiscount: true,
            ),
            _buildDetailRow(
              'Preço Pós-Desconto (Faixa):',
              currencyFormat.format(detail.rangeTotalPriceAfterDiscount),
              isFinal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isFinal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isFinal ? Theme.of(context).primaryColor : Colors.black87,
              fontWeight: isFinal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: isDiscount
                  ? Colors.red.shade700
                  : isFinal
                  ? Theme.of(context).primaryColor
                  : Colors.black87,
              fontWeight: isFinal || isDiscount
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
