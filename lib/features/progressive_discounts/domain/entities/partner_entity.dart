class PartnerEntity {
  final String id;
  final String name;
  final String discountType;
  final double dailyPrice;
  final int clientsAmount;
  final String discountsTableId;

  PartnerEntity({
    required this.id,
    required this.name,
    required this.discountType,
    required this.dailyPrice,
    required this.clientsAmount,
    required this.discountsTableId,
  });

  PartnerEntity copyWith({
    String? id,
    String? name,
    String? discountType,
    double? dailyPrice,
    int? clientsAmount,
    String? discountsTableId,
  }) {
    return PartnerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      discountType: discountType ?? this.discountType,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      clientsAmount: clientsAmount ?? this.clientsAmount,
      discountsTableId: discountsTableId ?? this.discountsTableId,
    );
  }
}
