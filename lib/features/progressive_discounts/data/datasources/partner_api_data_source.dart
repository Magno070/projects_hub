import 'package:projects_hub/features/progressive_discounts/data/models/partner_discount_log.dart';
import 'package:projects_hub/features/progressive_discounts/data/models/partner_model.dart';

abstract class PartnerApiDataSource {
  Future<void> createPartner(PartnerModel model);

  Future<List<PartnerModel>> getAllPartners();

  Future<PartnerModel?> getPartner(String partnerId);

  Future<void> updatePartner({
    required String partnerId,
    String? name,
    String? discountType,
    double? dailyPrice,
    int? clientsAmount,
    String? discountsTableId,
  });

  Future<void> deletePartner(String partnerId);

  Future<List<PartnerDiscountLogModel>> getCalculationHistory(String partnerId);
}
