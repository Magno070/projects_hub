import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:projects_hub/core/helpers/debouncer.dart';
import 'package:projects_hub/core/router/app_router.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/partners_viewmodel.dart';

class PartnerItem extends StatefulWidget {
  final PartnerEntity partner;
  final PartnersViewModel viewModel;
  final List<DiscountTableEntity> allTables;
  final bool isSelected;

  const PartnerItem({
    super.key,
    required this.partner,
    required this.viewModel,
    required this.allTables,
    required this.isSelected,
  });

  @override
  State<PartnerItem> createState() => _PartnerItemState();
}

class _PartnerItemState extends State<PartnerItem> {
  late final TextEditingController _priceController;
  late final TextEditingController _clientsController;
  final _priceDebouncer = Debouncer(milliseconds: 500);
  final _clientsDebouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.partner.dailyPrice.toString(),
    );
    _clientsController = TextEditingController(
      text: widget.partner.clientsAmount.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant PartnerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se o widget for atualizado com um parceiro *diferente*,
    // reseta os c
    //ontroladores de texto.
    if (widget.partner.id != oldWidget.partner.id) {
      _priceController.text = widget.partner.dailyPrice.toString();
      _clientsController.text = widget.partner.clientsAmount.toString();
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _clientsController.dispose();
    _priceDebouncer.dispose();
    _clientsDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partnerTable = widget.allTables.firstWhere(
      (table) => table.id == widget.partner.discountsTableId,
      orElse: () => DiscountTableEntity(
        id: '',
        nickname: 'Tabela não encontrada',
        discountType: '',
        ranges: [],
      ),
    );

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
            title: Text(widget.partner.name),
            subtitle: Text(
              'Tabela: ${partnerTable.nickname} (${partnerTable.discountType})',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => context.push(
                    AppRoutes.progressiveDiscountsViewPartnerInfo.replaceAll(
                      ':partnerId',
                      widget.partner.id,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context),
                ),
                Icon(widget.isSelected ? Icons.expand_less : Icons.expand_more),
              ],
            ),
            onTap: () {
              widget.viewModel.selectPartner(widget.partner.id);
            },
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: widget.isSelected
                ? _buildEditableBody(context, partnerTable)
                : const SizedBox.shrink(),
            crossFadeState: widget.isSelected
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableBody(
    BuildContext context,
    DiscountTableEntity partnerTable,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            controller: _priceController,
            label: 'Preço Diário (R\$)',
            icon: Icons.monetization_on_outlined,
            debouncer: _priceDebouncer,
            isDecimal: true,
            onChanged: (value) {
              final price = double.tryParse(value);
              if (price != null && price > 0) {
                widget.viewModel.updateDailyPrice(widget.partner.id, price);
              }
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            controller: _clientsController,
            label: 'Qtd. Clientes',
            icon: Icons.people_outline,
            debouncer: _clientsDebouncer,
            isDecimal: false,
            onChanged: (value) {
              final clients = int.tryParse(value);
              if (clients != null && clients >= 0) {
                widget.viewModel.updateClientsAmount(
                  widget.partner.id,
                  clients,
                );
              }
            },
          ),
          const SizedBox(height: 16),
          _buildDropdown(context, partnerTable),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Parceiro'),
          content: Text(
            'Tem certeza que deseja excluir "${widget.partner.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                widget.viewModel.deletePartner(widget.partner.id);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Debouncer debouncer,
    required bool isDecimal,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: isDecimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      inputFormatters: [
        if (isDecimal)
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        debouncer.run(() => onChanged(value));
      },
    );
  }

  Widget _buildDropdown(
    BuildContext context,
    DiscountTableEntity partnerTable,
  ) {
    return DropdownButtonFormField<String>(
      value: partnerTable.id,
      decoration: const InputDecoration(
        labelText: 'Tabela de Desconto',
        prefixIcon: Icon(Icons.table_chart),
        border: OutlineInputBorder(),
      ),
      items: widget.allTables.map((table) {
        return DropdownMenuItem<String>(
          value: table.id,
          child: Text(
            '${table.nickname} (${table.discountType == "base" ? "Tabela de descontos geral" : "Personalizada"})',
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null && value != widget.partner.discountsTableId) {
          widget.viewModel.updateDiscountTable(widget.partner.id, value);
        }
      },
    );
  }
}
