// lib/features/progressive_discounts/presentation/pages/partner_info_page.dart

import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/partners_viewmodel.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/partner_discount_log_item/partner_discount_log_item.dart';
import 'package:provider/provider.dart';

class PartnerInfoPage extends StatefulWidget {
  final String partnerId;

  const PartnerInfoPage({super.key, required this.partnerId});

  @override
  State<PartnerInfoPage> createState() => _PartnerInfoPageState();
}

class _PartnerInfoPageState extends State<PartnerInfoPage> {
  PartnerEntity? partner;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<PartnersViewModel>(context, listen: false);

      // 1. Carregar o parceiro
      viewModel.getPartner(widget.partnerId).then((
        PartnerEntity? fetchedPartner,
      ) {
        if (mounted) {
          setState(() {
            partner = fetchedPartner;
          });

          // 2. Carregar o histórico de cálculos se o parceiro for encontrado
          if (partner != null) {
            viewModel.getCalculationHistory(partner!.id);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PartnersViewModel>();

    if (partner == null) {
      if (viewModel.isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return Scaffold(
        appBar: AppBar(title: const Text("Registro de Cálculos")),
        body: const Center(child: Text('Parceiro não encontrado.')),
      );
    }

    final partnerName = partner!.name;

    return Scaffold(
      appBar: AppBar(title: Text("Registro de cálculos: $partnerName")),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Calcular Desconto',
        onPressed: viewModel.isLoading
            ? null
            : () {
                viewModel.calculateDiscounts(
                  partner!.id,
                  partner!.discountsTableId,
                );
              },
        child: const Icon(Icons.calculate_outlined),
      ),
      body: Column(
        children: [
          if (viewModel.isLoading) const LinearProgressIndicator(),
          if (viewModel.errorMessage != null && !viewModel.isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Erro: ${viewModel.errorMessage}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          Expanded(child: _buildLogHistoryList(viewModel)),
        ],
      ),
    );
  }

  Widget _buildLogHistoryList(PartnersViewModel viewModel) {
    if (viewModel.isLoading && viewModel.calculationHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    if (viewModel.calculationHistory.isEmpty) {
      return const Center(
        child: Text('Nenhum histórico de cálculo encontrado.'),
      );
    }

    final sortedHistory = viewModel.calculationHistory.toList()
      ..sort((a, b) => b.calculationDate.compareTo(a.calculationDate));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      itemCount: sortedHistory.length,
      itemBuilder: (context, index) {
        final log = sortedHistory[index];
        return PartnerLogItem(viewModel: viewModel, log: log);
      },
    );
  }
}
