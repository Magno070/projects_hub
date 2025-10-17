import 'package:flutter/material.dart';

class TableCell extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color borderColor;
  final bool isLast;
  final bool isFirstRow;
  const TableCell({
    super.key,
    required this.child,
    required this.color,
    this.borderColor = Colors.black,
    this.isLast = false,
    this.isFirstRow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border(
          top: isFirstRow ? BorderSide.none : BorderSide(color: borderColor),
          left: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
          right: isLast ? BorderSide(color: borderColor) : BorderSide.none,
        ),
      ),
      child: child,
    );
  }
}
