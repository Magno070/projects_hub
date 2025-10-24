import 'package:projects_hub/features/progressive_discounts/data/models/discounts_table_model.dart';

class DiscountTableEntity {
  final String id;
  final String nickname;
  final String discountType;
  final List<DiscountTableRangeEntity> ranges;

  DiscountTableEntity({
    required this.id,
    required this.nickname,
    required this.discountType,
    required this.ranges,
  });

  factory DiscountTableEntity.fromModel(DiscountsTableModel model) {
    return DiscountTableEntity(
      id: model.id,
      nickname: model.nickname,
      discountType: model.discountType,
      ranges: model.ranges
          .map((range) => DiscountTableRangeEntity.fromModel(range))
          .toList(),
    );
  }

  DiscountsTableModel toModel() {
    return DiscountsTableModel(
      id: id,
      nickname: nickname,
      discountType: discountType,
      ranges: ranges.map((range) => range.toModel()).toList(),
    );
  }

  DiscountTableEntity copyWith({
    String? id,
    String? nickname,
    String? discountType,
    List<DiscountTableRangeEntity>? ranges,
  }) {
    return DiscountTableEntity(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      discountType: discountType ?? this.discountType,
      ranges: ranges ?? this.ranges,
    );
  }
}

class DiscountTableRangeEntity {
  final int initialRange;
  final int finalRange;
  final double discount;

  DiscountTableRangeEntity({
    required this.initialRange,
    required this.finalRange,
    required this.discount,
  });

  factory DiscountTableRangeEntity.fromModel(DiscountRange model) {
    return DiscountTableRangeEntity(
      initialRange: model.initialRange,
      finalRange: model.finalRange,
      discount: model.discount,
    );
  }

  DiscountRange toModel() {
    return DiscountRange(
      initialRange: initialRange,
      finalRange: finalRange,
      discount: discount,
    );
  }

  DiscountTableRangeEntity copyWith({
    int? initialRange,
    int? finalRange,
    double? discount,
  }) {
    return DiscountTableRangeEntity(
      initialRange: initialRange ?? this.initialRange,
      finalRange: finalRange ?? this.finalRange,
      discount: discount ?? this.discount,
    );
  }
}
