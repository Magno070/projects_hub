// lib/features/progressive_discounts/presentation/pages/partner_info_page.dart

import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/partners_viewmodel.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/partner_discount_log_item.dart';
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
        // Se estiver carregando, mostra um indicador global
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      // Se não estiver carregando e o parceiro for nulo, mostra erro
      return Scaffold(
        appBar: AppBar(title: const Text("Registro de Cálculos")),
        body: const Center(child: Text('Parceiro não encontrado.')),
      );
    }

    final partnerName = partner!.name;

    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de cálculos: $partnerName"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate_outlined),
            tooltip: 'Calcular Desconto',
            onPressed: viewModel.isLoading
                ? null
                : () {
                    // Chama a função de cálculo no ViewModel
                    viewModel.calculateDiscounts(
                      partner!.id,
                      partner!.discountsTableId,
                    );
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          // Exibe a barra de progresso para as operações de cálculo/histórico
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

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(Icons.history, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Histórico de Cálculos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(child: _buildLogHistoryList(viewModel)),
        ],
      ),
    );
  }

  Widget _buildLogHistoryList(PartnersViewModel viewModel) {
    if (viewModel.isLoading && viewModel.calculationHistory.isEmpty) {
      // Se estiver carregando mas a lista ainda está vazia (primeiro load),
      // o indicador de progresso global já é suficiente.
      return const SizedBox.shrink();
    }

    if (viewModel.calculationHistory.isEmpty) {
      return const Center(
        child: Text('Nenhum histórico de cálculo encontrado.'),
      );
    }

    // Ordenar do mais recente para o mais antigo (melhor UX para logs)
    final sortedHistory = viewModel.calculationHistory.toList()
      ..sort((a, b) => b.calculationDate.compareTo(a.calculationDate));

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: sortedHistory.length,
      itemBuilder: (context, index) {
        final log = sortedHistory[index];
        return PartnerLogItem(viewModel: viewModel, log: log);
      },
    );
  }
}
