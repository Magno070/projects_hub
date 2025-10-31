import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/partners_viewmodel.dart';

class PartnerLogItem extends StatefulWidget {
  final PartnersViewModel viewModel;
  const PartnerLogItem({super.key, required this.viewModel});

  @override
  State<PartnerLogItem> createState() => _PartnerLogItemState();
}

class _PartnerLogItemState extends State<PartnerLogItem> {
  @override
  Widget build(BuildContext context) {
    return Card(child: Column(children: [
      
        ],
      ));
  }
}
