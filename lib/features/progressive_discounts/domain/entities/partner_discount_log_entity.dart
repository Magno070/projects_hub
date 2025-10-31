import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';

class PartnerDiscountLogEntity {
  final String id;
  final String partnerId;
  final String discountTableId;
  final double partnerDailyPriceStamp;
  final int partnerClientsAmountStamp;
  final double totalPriceResult;
  final double totalDiscountResult;
  final double totalPriceAfterDiscountResult;
  final DateTime calculationDate;
  final List<DiscountTableRangeEntity> discountRangesStamp;
  final List<PartnerDiscountLogDetailsEntity> details;

  PartnerDiscountLogEntity({
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

  PartnerDiscountLogEntity copyWith({
    String? id,
    String? partnerId,
    String? discountTableId,
    double? partnerDailyPriceStamp,
    int? partnerClientsAmountStamp,
    double? totalPriceResult,
    double? totalDiscountResult,
    double? totalPriceAfterDiscountResult,
    DateTime? calculationDate,
    List<DiscountTableRangeEntity>? discountRangesStamp,
    List<PartnerDiscountLogDetailsEntity>? details,
  }) {
    return PartnerDiscountLogEntity(
      id: id ?? this.id,
      partnerId: partnerId ?? this.partnerId,
      discountTableId: discountTableId ?? this.discountTableId,
      partnerDailyPriceStamp:
          partnerDailyPriceStamp ?? this.partnerDailyPriceStamp,
      partnerClientsAmountStamp:
          partnerClientsAmountStamp ?? this.partnerClientsAmountStamp,
      totalPriceResult: totalPriceResult ?? this.totalPriceResult,
      totalDiscountResult: totalDiscountResult ?? this.totalDiscountResult,
      totalPriceAfterDiscountResult:
          totalPriceAfterDiscountResult ?? this.totalPriceAfterDiscountResult,
      calculationDate: calculationDate ?? this.calculationDate,
      discountRangesStamp: discountRangesStamp ?? this.discountRangesStamp,
      details: details ?? this.details,
    );
  }
}

class PartnerDiscountLogDetailsEntity {
  final int initialRange;
  final int finalRange;
  final double discount;
  final int rangeTotalClientsAmount;
  final double rangeTotalPrice;
  final double rangeTotalDiscount;
  final double rangeTotalPriceAfterDiscount;

  PartnerDiscountLogDetailsEntity({
    required this.initialRange,
    required this.finalRange,
    required this.discount,
    required this.rangeTotalClientsAmount,
    required this.rangeTotalPrice,
    required this.rangeTotalDiscount,
    required this.rangeTotalPriceAfterDiscount,
  });

  PartnerDiscountLogDetailsEntity copyWith({
    int? initialRange,
    int? finalRange,
    double? discount,
    int? rangeTotalClientsAmount,
    double? rangeTotalPrice,
    double? rangeTotalDiscount,
    double? rangeTotalPriceAfterDiscount,
  }) {
    return PartnerDiscountLogDetailsEntity(
      initialRange: initialRange ?? this.initialRange,
      finalRange: finalRange ?? this.finalRange,
      discount: discount ?? this.discount,
      rangeTotalClientsAmount:
          rangeTotalClientsAmount ?? this.rangeTotalClientsAmount,
      rangeTotalPrice: rangeTotalPrice ?? this.rangeTotalPrice,
      rangeTotalDiscount: rangeTotalDiscount ?? this.rangeTotalDiscount,
      rangeTotalPriceAfterDiscount:
          rangeTotalPriceAfterDiscount ?? this.rangeTotalPriceAfterDiscount,
    );
  }
}
