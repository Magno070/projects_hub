import 'package:flutter/material.dart';

class TableCell extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color borderColor;
  final bool isLast;
  final bool isHeader;
  const TableCell({
    super.key,
    required this.child,
    required this.color,
    this.borderColor = Colors.black,
    this.isLast = false,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border(
          top: BorderSide(color: borderColor),
          left: BorderSide(color: borderColor),
          bottom: isHeader ? BorderSide.none : BorderSide(color: borderColor),
          right: isLast ? BorderSide(color: borderColor) : BorderSide.none,
        ),
      ),
      child: child,
    );
  }
}

/// TableCell that when clicked, turns into an editable text field
class EditableTableCell extends StatefulWidget {
  final String text;
  final Color color;
  final Color borderColor;
  final bool isLast;
  final bool isHeader;
  final bool isLastRow;
  final Function(String)? onValueChanged;
  const EditableTableCell({
    super.key,
    required this.text,
    required this.color,
    this.borderColor = Colors.black,
    this.isLast = false,
    this.isHeader = false,
    this.onValueChanged,
    this.isLastRow = false,
  });

  @override
  State<EditableTableCell> createState() => _EditableTableCellState();
}

class _EditableTableCellState extends State<EditableTableCell> {
  late TextEditingController _controller;
  bool _isEditing = false;
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.text;
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    _controller.text = _currentValue;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  void _finishEditing() {
    setState(() {
      _isEditing = false;
      _currentValue = _controller.text;
    });
    widget.onValueChanged?.call(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isEditing ? null : _startEditing,
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          border: Border(
            top: widget.isHeader
                ? BorderSide.none
                : BorderSide(color: widget.borderColor),
            left: BorderSide(color: widget.borderColor),
            bottom: widget.isLastRow
                ? BorderSide(color: widget.borderColor)
                : BorderSide.none,
            right: widget.isLast
                ? BorderSide(color: widget.borderColor)
                : BorderSide.none,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: _isEditing
              ? TextField(
                  maxLines: 1,
                  controller: _controller,
                  style: const TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  autofocus: true,
                  onTapOutside: (_) => _finishEditing(),
                  onSubmitted: (_) => _finishEditing(),
                )
              : Text(_currentValue, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
