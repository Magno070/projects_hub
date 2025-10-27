class DiscountsTableModel {
  final String id;
  final String nickname;
  final String discountType;
  final List<DiscountRange> ranges;

  DiscountsTableModel({
    required this.id,
    required this.nickname,
    required this.discountType,
    required this.ranges,
  });

  factory DiscountsTableModel.fromJson(Map<String, dynamic> json) {
    return DiscountsTableModel(
      id: json['_id'],
      nickname: json['nickname'],
      discountType: json['discountType'],
      ranges: (json['ranges'] as List)
          .map((rangeJson) => DiscountRange.fromJson(rangeJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'discountType': discountType,
      'ranges': ranges.map((range) => range.toJson()).toList(),
    };
  }

  // Método para serialização na criação (sem o campo id)
  Map<String, dynamic> toJsonForCreation() {
    return {
      'nickname': nickname,
      'discountType': discountType,
      'ranges': ranges.map((range) => range.toJson()).toList(),
    };
  }
}

class DiscountRange {
  final int initialRange;
  final int finalRange;
  final double discount;

  DiscountRange({
    required this.initialRange,
    required this.finalRange,
    required this.discount,
  });

  factory DiscountRange.fromJson(Map<String, dynamic> json) {
    return DiscountRange(
      initialRange: json['initialRange'],
      finalRange: json['finalRange'],
      discount: (json['discount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'initialRange': initialRange,
      'finalRange': finalRange,
      'discount': discount,
    };
  }
}
