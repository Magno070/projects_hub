import 'package:projects_hub/features/progressive_discounts/data/models/partner_model.dart';

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

  factory PartnerEntity.fromModel(PartnerModel model) {
    return PartnerEntity(
      id: model.id,
      name: model.name,
      discountType: model.discountType,
      dailyPrice: model.dailyPrice,
      clientsAmount: model.clientsAmount,
      discountsTableId: model.discountsTableId,
    );
  }

  PartnerModel toModel() {
    return PartnerModel(
      id: id,
      name: name,
      discountType: discountType,
      dailyPrice: dailyPrice,
      clientsAmount: clientsAmount,
      discountsTableId: discountsTableId,
    );
  }

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
