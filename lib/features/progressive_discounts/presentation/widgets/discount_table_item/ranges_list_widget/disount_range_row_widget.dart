import 'package:flutter/material.dart';

enum _Field { initialRange, finalRange, discount }

class EditableRange {
  int initialRange;
  int finalRange;
  double discount;

  EditableRange({
    required this.initialRange,
    required this.finalRange,
    required this.discount,
  });
}

class RangeRow extends StatefulWidget {
  final int index;
  final EditableRange range;
  final bool isEditable;
  final bool isLast;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const RangeRow({
    super.key,
    required this.index,
    required this.range,
    required this.isEditable,
    required this.isLast,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<RangeRow> createState() => RangeRowState();
}

class RangeRowState extends State<RangeRow> {
  _Field? _activeField;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _activeField != null) {
        _commitEditingValue();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final range = widget.range;
    final rangeColor = _getRangeColor(context, range.discount);

    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
              blurRadius: 2.0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.isEditable)
                      Row(
                        children: [
                          Flexible(
                            child: _buildEditableCell(
                              label: 'Início',
                              displayValue: range.initialRange.toString(),
                              isActive: _activeField == _Field.initialRange,
                              keyboardType: TextInputType.number,
                              onTap: () => _startEditing(_Field.initialRange),
                              onSubmitted: (_) => _commitEditingValue(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: _buildEditableCell(
                              label: 'Fim',
                              displayValue: range.finalRange.toString(),
                              isActive: _activeField == _Field.finalRange,
                              keyboardType: TextInputType.number,
                              onTap: () => _startEditing(_Field.finalRange),
                              onSubmitted: (_) => _commitEditingValue(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: _buildEditableCell(
                              label: 'Desconto (%)',
                              displayValue: range.discount.toStringAsFixed(1),
                              isActive: _activeField == _Field.discount,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              onTap: () => _startEditing(_Field.discount),
                              onSubmitted: (_) => _commitEditingValue(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            tooltip: 'Remover faixa',
                            onPressed: widget.canRemove
                                ? widget.onRemove
                                : null,
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      )
                    else ...[
                      Text(
                        '${range.initialRange} - ${range.finalRange} clientes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Faixa ${widget.index + 1}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: rangeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: rangeColor.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  '${range.discount.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: rangeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startEditing(_Field field) {
    setState(() {
      _activeField = field;
      switch (field) {
        case _Field.initialRange:
          _controller.text = widget.range.initialRange.toString();
          break;
        case _Field.finalRange:
          _controller.text = widget.range.finalRange.toString();
          break;
        case _Field.discount:
          _controller.text = widget.range.discount.toStringAsFixed(1);
          break;
      }
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _commitEditingValue() {
    if (_activeField == null) return;
    final text = _controller.text.trim().replaceAll(',', '.');
    final range = widget.range;
    bool changed = false;
    switch (_activeField!) {
      case _Field.initialRange:
        final parsedInitial = int.tryParse(text);
        if (parsedInitial != null && parsedInitial != range.initialRange) {
          range.initialRange = parsedInitial;
          changed = true;
        }
        break;
      case _Field.finalRange:
        final parsedFinal = int.tryParse(text);
        if (parsedFinal != null && parsedFinal != range.finalRange) {
          range.finalRange = parsedFinal;
          changed = true;
        }
        break;
      case _Field.discount:
        final parsedDiscount = double.tryParse(text);
        if (parsedDiscount != null && parsedDiscount != range.discount) {
          range.discount = parsedDiscount;
          changed = true;
        }
        break;
    }
    setState(() {
      _activeField = null;
      _controller.clear();
    });
    if (changed) {
      widget.onChanged();
    }
  }

  Widget _buildEditableCell({
    required String label,
    required String displayValue,
    required bool isActive,
    required TextInputType keyboardType,
    required VoidCallback onTap,
    required ValueChanged<String> onSubmitted,
  }) {
    if (isActive) {
      return TextField(
        focusNode: _focusNode,
        controller: _controller,
        autofocus: true,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        onSubmitted: onSubmitted,
      );
    }
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(displayValue),
      ),
    );
  }

  Color _getRangeColor(BuildContext context, double discount) {
    if (discount >= 20.0) {
      return Colors.green.shade600;
    } else if (discount >= 10.0) {
      return Colors.orange.shade600;
    } else if (discount >= 5.0) {
      return Colors.amber.shade600;
    } else {
      return Colors.blue.shade600;
    }
  }
}
