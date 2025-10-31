import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/partners_viewmodel.dart';

class AddPartnerDialog extends StatefulWidget {
  final PartnersViewModel viewModel;
  final List<DiscountTableEntity> allTables;

  const AddPartnerDialog({
    super.key,
    required this.viewModel,
    required this.allTables,
  });

  @override
  State<AddPartnerDialog> createState() => _AddPartnerDialogState();
}

class _AddPartnerDialogState extends State<AddPartnerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _clientsController = TextEditingController();
  String? _selectedTableId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _clientsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final success = await widget.viewModel.createPartner(
        name: _nameController.text,
        dailyPrice: double.parse(_priceController.text),
        clientsAmount: int.parse(_clientsController.text),
        discountsTableId: _selectedTableId!,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.watch<PartnersViewModel>().errorMessage;

    return AlertDialog(
      title: const Text('Novo Parceiro'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Parceiro',
                  icon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Preço Diário (R\$)',
                  icon: Icon(Icons.monetization_on_outlined),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Campo obrigatório';
                  if ((double.tryParse(value!) ?? 0) <= 0) {
                    return 'Valor deve ser maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _clientsController,
                decoration: const InputDecoration(
                  labelText: 'Qtd. Clientes',
                  icon: Icon(Icons.people_outline),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Campo obrigatório';
                  if ((int.tryParse(value!) ?? -1) < 0) {
                    return 'Valor não pode ser negativo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTableId,
                decoration: const InputDecoration(
                  labelText: 'Tabela de Desconto',
                  icon: Icon(Icons.table_chart),
                ),
                items: widget.allTables.map((table) {
                  return DropdownMenuItem<String>(
                    value: table.id,
                    child: Text('${table.nickname} (${table.discountType})'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedTableId = value),
                validator: (value) =>
                    value == null ? 'Selecione uma tabela' : null,
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: CircularProgressIndicator(),
                ),
              if (errorMessage != null && !_isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Erro: $errorMessage',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _submit,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
