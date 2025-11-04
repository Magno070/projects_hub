import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/progressive_discounts_viewmodel.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/discount_table_item/ranges_list_widget.dart';

class DiscountTableItem extends StatelessWidget {
  final DiscountTableEntity table;
  final ProgressiveDiscountsViewModel viewModel;
  final bool isSelected;
  final bool isBaseTable;

  const DiscountTableItem({
    super.key,
    required this.table,
    required this.viewModel,
    required this.isSelected,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(table.nickname),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditNicknameDialog(context);
                        break;
                      case 'clone':
                        viewModel.cloneTable(table.id);
                        break;
                      case 'delete':
                        viewModel.deleteTable(table.id);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (!isBaseTable)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Editar Nome'),
                      ),
                    const PopupMenuItem(value: 'clone', child: Text('Clonar')),
                    if (!isBaseTable)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Excluir'),
                      ),
                  ],
                ),
                Icon(isSelected ? Icons.expand_less : Icons.expand_more),
              ],
            ),
            onTap: () {
              viewModel.selectTable(table.id);
            },
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: isSelected
                ? RangesListWidget(ranges: table.ranges)
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
}
