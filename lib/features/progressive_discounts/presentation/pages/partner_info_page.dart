import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/partners_viewmodel.dart';
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
      Provider.of<PartnersViewModel>(
        context,
        listen: false,
      ).getPartner(widget.partnerId).then((PartnerEntity? partner) {
        if (mounted) {
          setState(() {
            this.partner = partner;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PartnersViewModel>();

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(child: Text('Erro: ${viewModel.errorMessage}'));
    }

    if (partner == null) {
      return const Center(child: Text('Parceiro não encontrado.'));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Registro de cálculos: ${partner!.name}")),
      body: Column(
        children: [
          Text('Preço Diário: ${partner!.dailyPrice.toString()}'),
          Text('Quantidade de Clientes: ${partner!.clientsAmount.toString()}'),
          Text('Tabela de Desconto: ${partner!.discountsTableId}'),
        ],
      ),
    );
  }
}
