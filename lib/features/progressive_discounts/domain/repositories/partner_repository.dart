import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_entity.dart';

abstract class PartnerRepository {
  Future<void> createPartner(PartnerEntity entity);

  Future<List<PartnerEntity>> getAllPartners();

  Future<PartnerEntity> getPartner(String partnerId);

  Future<void> updatePartner(
    String partnerId,
    String? name,
    String? discountType,
    double? dailyPrice,
    int? clientsAmount,
    String? discountsTableId,
  );

  Future<void> deletePartner(String partnerId);
}
