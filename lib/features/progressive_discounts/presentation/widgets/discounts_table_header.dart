import 'package:flutter/material.dart';
import 'package:projects_hub/shared/widgets/table_cell.dart' as shared;

class DiscountsTableHeader extends StatelessWidget {
  const DiscountsTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTableCell('Faixa'),
        _buildTableCell('Desconto'),
        _buildTableCell('Valor'),
        _buildTableCell('Total', isLast: true),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isLast = false}) {
    return Expanded(
      child: shared.TableCell(
        color: const Color.fromARGB(255, 219, 219, 219),
        borderColor: Colors.black,
        isLast: isLast,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
