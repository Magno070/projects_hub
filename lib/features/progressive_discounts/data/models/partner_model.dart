class PartnerModel {
  final String id;
  final String name;
  final String discountType;
  final double dailyPrice;
  final int clientsAmount;
  final String discountsTableId;

  PartnerModel({
    required this.id,
    required this.name,
    required this.discountType,
    required this.dailyPrice,
    required this.clientsAmount,
    required this.discountsTableId,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      id: json['_id'],
      name: json['name'],
      discountType: json['discountType'],
      dailyPrice: json['dailyPrice'],
      clientsAmount: json['clientsAmount'],
      discountsTableId: json['discountsTableId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'discountType': discountType,
      'dailyPrice': dailyPrice,
      'clientsAmount': clientsAmount,
      'discountsTableId': discountsTableId,
    };
  }

  Map<String, dynamic> toJsonForCreation() {
    return {
      'name': name,
      'discountType': discountType,
      'dailyPrice': dailyPrice,
      'clientsAmount': clientsAmount,
      'discountsTableId': discountsTableId,
    };
  }
}
