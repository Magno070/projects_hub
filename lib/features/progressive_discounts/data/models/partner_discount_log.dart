import 'package:projects_hub/features/progressive_discounts/data/models/discounts_table_model.dart';

class PartnerDiscountLogModel {
  final String id;
  final String partnerId;
  final String discountTableId;
  final double partnerDailyPriceStamp;
  final int partnerClientsAmountStamp;
  final double totalPriceResult;
  final double totalDiscountResult;
  final double totalPriceAfterDiscountResult;
  final DateTime calculationDate;
  final List<DiscountRange> discountRangesStamp;
  final List<PartnerDiscountLogDetailsModel> details;

  PartnerDiscountLogModel({
    required this.id,
    required this.partnerId,
    required this.discountTableId,
    required this.partnerDailyPriceStamp,
    required this.partnerClientsAmountStamp,
    required this.totalPriceResult,
    required this.totalDiscountResult,
    required this.totalPriceAfterDiscountResult,
    required this.calculationDate,
    required this.discountRangesStamp,
    required this.details,
  });

  factory PartnerDiscountLogModel.fromJson(Map<String, dynamic> json) {
    return PartnerDiscountLogModel(
      id: json['_id'],
      partnerId: json['partnerId'],
      discountTableId: json['discountTableId'],
      partnerDailyPriceStamp: json['partnerDailyPriceStamp'],
      partnerClientsAmountStamp: json['partnerClientsAmountStamp'],
      totalPriceResult: json['totalPriceResult'],
      totalDiscountResult: json['totalDiscountResult'],
      totalPriceAfterDiscountResult: json['totalPriceAfterDiscountResult'],
      calculationDate: DateTime.parse(json['calculationDate']),
      discountRangesStamp: (json['discountRangesStamp'] as List)
          .map((rangeJson) => DiscountRange.fromJson(rangeJson))
          .toList(),
      details: (json['details'] as List)
          .map(
            (detailJson) => PartnerDiscountLogDetailsModel.fromJson(detailJson),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJsonForCreation() {
    return {
      'partnerId': partnerId,
      'discountTableId': discountTableId,
      'partnerDailyPriceStamp': partnerDailyPriceStamp,
      'partnerClientsAmountStamp': partnerClientsAmountStamp,
      'totalPriceResult': totalPriceResult,
    };
  }
}

class PartnerDiscountLogDetailsModel {
  final int initialRange;
  final int finalRange;
  final double discount;
  final int rangeTotalClientsAmount;
  final double rangeTotalPrice;
  final double rangeTotalDiscount;
  final double rangeTotalPriceAfterDiscount;

  PartnerDiscountLogDetailsModel({
    required this.initialRange,
    required this.finalRange,
    required this.discount,
    required this.rangeTotalClientsAmount,
    required this.rangeTotalPrice,
    required this.rangeTotalDiscount,
    required this.rangeTotalPriceAfterDiscount,
  });

  factory PartnerDiscountLogDetailsModel.fromJson(Map<String, dynamic> json) {
    return PartnerDiscountLogDetailsModel(
      initialRange: json['initialRange'],
      finalRange: json['finalRange'],
      discount: json['discount'],
      rangeTotalClientsAmount: json['rangeTotalClientsAmount'],
      rangeTotalPrice: json['rangeTotalPrice'],
      rangeTotalDiscount: json['rangeTotalDiscount'],
      rangeTotalPriceAfterDiscount: json['rangeTotalPriceAfterDiscount'],
    );
  }
}
