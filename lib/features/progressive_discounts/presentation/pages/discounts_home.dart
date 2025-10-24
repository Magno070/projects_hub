import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/discounts_table_header.dart';

class DiscountsHome extends StatelessWidget {
  const DiscountsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Simulação de descontos por faixa de clientes\nDefina o valor que uma determinada faixa de clientes receberá de desconto\nAo final será exibido a soma de todos as faixas descontadas",
              style: TextStyle(fontSize: 18),
            ),
            DiscountsTableHeader(),
          ],
        ),
      ),
    );
  }
}
