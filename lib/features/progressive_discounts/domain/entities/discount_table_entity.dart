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
