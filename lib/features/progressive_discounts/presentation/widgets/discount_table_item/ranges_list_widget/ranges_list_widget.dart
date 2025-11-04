import 'package:flutter/material.dart';

import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/widgets/discount_table_item/ranges_list_widget/disount_range_row_widget.dart';

class RangesListWidget extends StatefulWidget {
  final List<DiscountTableRangeEntity> ranges;
  final void Function(List<DiscountTableRangeEntity> updatedRanges)? onSave;

  const RangesListWidget({super.key, required this.ranges, this.onSave});

  @override
  State<RangesListWidget> createState() => _RangesListWidgetState();
}

class _RangesListWidgetState extends State<RangesListWidget> {
  late List<EditableRange> _editableRanges;

  @override
  void initState() {
    super.initState();
    _editableRanges = widget.ranges
        .map(
          (r) => EditableRange(
            initialRange: r.initialRange,
            finalRange: r.finalRange,
            discount: r.discount,
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditable = widget.onSave != null;

    return Container(
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Theme.of(context).colorScheme.secondary,
                size: 18.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Faixas de Desconto',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (isEditable) ...[
                TextButton.icon(
                  onPressed: _addRange,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar faixa'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _onSave,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Salvar'),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12.0),

          ..._editableRanges.asMap().entries.map((entry) {
            final index = entry.key;
            final range = entry.value;
            final isLast = index == _editableRanges.length - 1;
            return RangeRow(
              key: ObjectKey(range),
              index: index,
              range: range,
              isEditable: isEditable,
              isLast: isLast,
              canRemove: _editableRanges.length > 1,
              onRemove: () => _removeRange(index),
              onChanged: () => setState(() {}),
            );
          }),

          if (_editableRanges.isNotEmpty) ...[
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.secondaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 16.0,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Desconto varia de ${_editableRanges.first.discount.toStringAsFixed(1)}% a ${_editableRanges.last.discount.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _addRange() {
    setState(() {
      final last = _editableRanges.isNotEmpty ? _editableRanges.last : null;
      final start = (last?.finalRange ?? 0) + 1;
      _editableRanges.add(
        EditableRange(
          initialRange: start,
          finalRange: start + 9,
          discount: 0.0,
        ),
      );
    });
  }

  void _removeRange(int index) {
    setState(() {
      _editableRanges.removeAt(index);
    });
  }

  // Métodos de edição foram movidos para o widget de linha (_RangeRow)

  void _onSave() {
    try {
      FocusScope.of(context).unfocus();
      final toSave = _editableRanges
          .map(
            (e) => DiscountTableRangeEntity(
              initialRange: e.initialRange,
              finalRange: e.finalRange,
              discount: e.discount,
            ),
          )
          .toList();

      _validateRanges(toSave);

      widget.onSave?.call(toSave);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Invalid argument(s):', 'Erro:'),
          ),
        ),
      );
    }
  }

  void _validateRanges(List<DiscountTableRangeEntity> ranges) {
    if (ranges.isEmpty) {
      throw ArgumentError(
        'A tabela de descontos deve ter pelo menos uma faixa de desconto',
      );
    }

    final sorted = List<DiscountTableRangeEntity>.from(ranges)
      ..sort((a, b) => a.initialRange.compareTo(b.initialRange));

    if (sorted.first.initialRange != 1) {
      throw ArgumentError('A primeira faixa de desconto deve começar em 1');
    }

    for (final r in sorted) {
      if (r.initialRange >= r.finalRange) {
        throw ArgumentError(
          'A faixa de desconto inicial deve ser menor que a faixa de desconto final '
          '(Erro na faixa: ${r.initialRange}-${r.finalRange})',
        );
      }
    }

    for (int i = 0; i < sorted.length - 1; i++) {
      final a = sorted[i];
      final b = sorted[i + 1];
      if (a.finalRange >= b.initialRange) {
        throw ArgumentError(
          'As faixas de desconto não podem se sobrepor: '
          '(${a.initialRange}-${a.finalRange}) e (${b.initialRange}-${b.finalRange})',
        );
      }
    }

    final last = sorted.last;
    final expected = List.generate(last.finalRange, (i) => i + 1);
    final covered = <int>{};
    for (final r in sorted) {
      for (int n = r.initialRange; n <= r.finalRange; n++) {
        covered.add(n);
      }
    }
    final missing = expected.where((n) => !covered.contains(n)).toList();
    if (missing.isNotEmpty) {
      List<String> intervals = [];
      int? start;
      int? previous;
      for (var n in missing) {
        if (start == null) {
          start = n;
          previous = n;
        } else if (n == previous! + 1) {
          previous = n;
        } else {
          if (start == previous) {
            intervals.add('$start');
          } else {
            intervals.add('$start - $previous');
          }
          start = n;
          previous = n;
        }
      }
      if (start != null) {
        if (start == previous) {
          intervals.add('$start');
        } else {
          intervals.add('$start - $previous');
        }
      }
      throw ArgumentError(
        'Existem números não cobertos pelos ranges: ${intervals.join(', ')}',
      );
    }
  }
}
