import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Parceiros')),
      backgroundColor: Colors.white,
      body: Consumer<PartnersViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.partners.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text('Erro: ${viewModel.errorMessage}'));
          }

          if (viewModel.partners.isEmpty) {
            return const Center(child: Text('Nenhum parceiro encontrado.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: viewModel.partners.length,
              itemBuilder: (context, index) {
                final partner = viewModel.partners[index];
                return PartnerItem(
                  partner: partner,
                  viewModel: viewModel,
                  allTables: viewModel.allTables,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar diálogo/página de criação de parceiro
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
