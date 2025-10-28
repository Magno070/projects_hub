import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/add_partner_dialog.dart';
import 'package:provider/provider.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/partners_viewmodel.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/partner_item.dart';

class PartnersView extends StatefulWidget {
  const PartnersView({super.key});

  @override
  State<PartnersView> createState() => _PartnersViewState();
}

class _PartnersViewState extends State<PartnersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PartnersViewModel>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PartnersViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Parceiros')),
      backgroundColor: Colors.white,
      body: Consumer<PartnersViewModel>(
        builder: (context, consumerViewModel, child) {
          if (consumerViewModel.isLoading &&
              consumerViewModel.partners.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (consumerViewModel.errorMessage != null) {
            return Center(
              child: Text('Erro: ${consumerViewModel.errorMessage}'),
            );
          }

          if (consumerViewModel.partners.isEmpty) {
            return const Center(child: Text('Nenhum parceiro encontrado.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: consumerViewModel.partners.length,
              itemBuilder: (context, index) {
                final partner = consumerViewModel.partners[index];

                // --- MODIFICADO ---
                // Verifica se este item é o selecionado
                final isSelected =
                    consumerViewModel.selectedPartnerId == partner.id;

                return PartnerItem(
                  partner: partner,
                  viewModel: consumerViewModel,
                  allTables: consumerViewModel.allTables,
                  isSelected: isSelected, // Passa o status
                );
                // --- FIM DA MODIFICAÇÃO ---
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Limpa qualquer erro antigo antes de abrir o dialog
          viewModel.clearError();

          // MODIFICADO: Chama o showDialog
          showDialog(
            context: context,
            builder: (dialogContext) {
              // Usa ChangeNotifierProvider.value para prover o viewModel
              // já existente para o widget do dialog.
              return ChangeNotifierProvider.value(
                value: viewModel,
                child: AddPartnerDialog(
                  viewModel: viewModel,
                  allTables: viewModel.allTables,
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
