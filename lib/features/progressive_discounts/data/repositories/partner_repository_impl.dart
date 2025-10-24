import 'package:projects_hub/features/progressive_discounts/data/datasources/partner_api_data_source.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/repositories/partner_repository.dart';

class PartnerRepositoryImpl implements PartnerRepository {
  final PartnerApiDataSource _dataSource;

  PartnerRepositoryImpl(this._dataSource);

  @override
  Future<void> createPartner(PartnerEntity entity) async {
    await _dataSource.createPartner(entity.toModel());
  }

  @override
  Future<List<PartnerEntity>> getAllPartners() async {
    final models = await _dataSource.getAllPartners();
    return models.map((model) => PartnerEntity.fromModel(model)).toList();
  }

  @override
  Future<PartnerEntity> getPartner(String partnerId) async {
    final model = await _dataSource.getPartner(partnerId);
    return PartnerEntity.fromModel(model);
  }

  @override
  Future<void> updatePartner(
    String partnerId,
    String? name,
    String? discountType,
    double? dailyPrice,
    int? clientsAmount,
    String? discountsTableId,
  ) async {
    await _dataSource.updatePartner(
      partnerId,
      name,
      discountType,
      dailyPrice,
      clientsAmount,
      discountsTableId,
    );
  }

  @override
  Future<void> deletePartner(String partnerId) async {
    await _dataSource.deletePartner(partnerId);
  }
}
