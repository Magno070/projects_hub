// lib/features/progressive_discounts/presentation/widgets/partner_discount_log_item.dart

import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_discount_log_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/partners_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/partner_discount_log_item/discounts_details_table_widget.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/partner_discount_log_item/discounts_info_table_widget.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/partner_discount_log_item/discounts_summary_table_widget.dart';

class PartnerLogItem extends StatefulWidget {
  final PartnersViewModel viewModel;
  final PartnerDiscountLogEntity log;

  const PartnerLogItem({super.key, required this.viewModel, required this.log});

  @override
  State<PartnerLogItem> createState() => _PartnerLogItemState();
}

class _PartnerLogItemState extends State<PartnerLogItem> {
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.viewModel.selectedLogId == widget.log.id;
    final theme = Theme.of(context);

    return Card(
      color: Colors.white,
      elevation: isSelected ? 4 : 2,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.5)
              : theme.colorScheme.outline.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              widget.viewModel.selectLog(widget.log.id);
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: theme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              dateFormat.format(widget.log.calculationDate),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildSummaryChip(
                              'Bruto',
                              currencyFormat.format(
                                widget.log.totalPriceResult,
                              ),
                              Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            _buildSummaryChip(
                              'Desconto',
                              currencyFormat.format(
                                widget.log.totalDiscountResult,
                              ),
                              Colors.red.shade600,
                              isDiscount: true,
                            ),
                            const SizedBox(width: 8),
                            _buildSummaryChip(
                              'Final',
                              currencyFormat.format(
                                widget.log.totalPriceAfterDiscountResult,
                              ),
                              theme.primaryColor,
                              isHighlight: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isSelected ? Icons.expand_less : Icons.expand_more,
                    color: theme.primaryColor,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isSelected
                ? _buildLogDetails(context, widget.log)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(
    String label,
    String value,
    Color color, {
    bool isDiscount = false,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: isHighlight ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogDetails(BuildContext context, PartnerDiscountLogEntity log) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(
                    children: [
                      _buildSectionHeader(
                        'Informações do Registro',
                        Icons.info_outline,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DiscountsInfoTableWidget(
                            rows: [
                              ['Tabela de Desconto', log.tableNicknameStamp],
                              [
                                'Quantidade de Clientes',
                                '${log.partnerClientsAmountStamp} clientes',
                              ],
                              [
                                'Preço Diário',
                                currencyFormat.format(
                                  log.partnerDailyPriceStamp,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Resumo Final
                      _buildSectionHeader('Resumo Final', Icons.calculate),
                      const SizedBox(height: 12),
                      Expanded(
                        child: DiscountsSummaryTableWidget(
                          log: log,
                          currencyFormat: currencyFormat,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          // Tabela de Detalhes por Faixa
          _buildSectionHeader('Detalhamento por Faixa', Icons.table_chart),
          const SizedBox(height: 12),
          DiscountsDetailsTableWidget(details: log.details),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
