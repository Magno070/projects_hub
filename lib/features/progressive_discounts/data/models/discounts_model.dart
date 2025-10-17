class DiscountsModel {
  final List<DiscountRow> discounts;
  DiscountsModel({required this.discounts});

  factory DiscountsModel.fromJson(List<Map<String, dynamic>> discountData) {
    return DiscountsModel(
      discounts: discountData
          .map(
            (data) => DiscountRow(
              initialRange: data['initialRange'] as int,
              finalRange: data['finalRange'] as int,
              discount: data['discount'] as double,
            ),
          )
          .toList(),
    );
  }
}

class DiscountRow {
  final int initialRange;
  final int finalRange;
  final double discount;
  DiscountRow({
    required this.initialRange,
    required this.finalRange,
    required this.discount,
  });
}
