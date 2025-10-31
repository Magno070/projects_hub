import 'package:projects_hub/features/progressive_discounts/data/datasources/calculator_api_data_source.dart';
import 'package:projects_hub/features/progressive_discounts/data/datasources/partner_api_data_source.dart';
import 'package:projects_hub/features/progressive_discounts/data/models/partner_model.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_discount_log_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/repositories/partner_repository.dart';

class PartnerRepositoryImpl implements PartnerRepository {
  final PartnerApiDataSource _dataSource;
  final CalculatorApiDataSource _calculatorDataSource;

  PartnerRepositoryImpl(this._dataSource, this._calculatorDataSource);

  @override
  Future<void> createPartner(PartnerEntity entity) async {
    final model = PartnerModel(
      id: entity.id,
      name: entity.name,
      discountType: entity.discountType,
      dailyPrice: entity.dailyPrice,
      clientsAmount: entity.clientsAmount,
      discountsTableId: entity.discountsTableId,
    );
    await _dataSource.createPartner(model);
  }

  @override
  Future<List<PartnerEntity>> getAllPartners() async {
    final models = await _dataSource.getAllPartners();
    return models
        .map(
          (model) => PartnerEntity(
            id: model.id,
            name: model.name,
            discountType: model.discountType,
            dailyPrice: model.dailyPrice,
            clientsAmount: model.clientsAmount,
            discountsTableId: model.discountsTableId,
          ),
        )
        .toList();
  }

  @override
  Future<PartnerEntity?> getPartner(String partnerId) async {
    final model = await _dataSource.getPartner(partnerId);
    if (model == null) {
      return null;
    }
    return PartnerEntity(
      id: model.id,
      name: model.name,
      discountType: model.discountType,
      dailyPrice: model.dailyPrice,
      clientsAmount: model.clientsAmount,
      discountsTableId: model.discountsTableId,
    );
  }

  @override
  Future<void> updatePartner({
    required String partnerId,
    String? name,
    String? discountType,
    double? dailyPrice,
    int? clientsAmount,
    String? discountsTableId,
  }) async {
    await _dataSource.updatePartner(
      partnerId: partnerId,
      name: name,
      discountType: discountType,
      dailyPrice: dailyPrice,
      clientsAmount: clientsAmount,
      discountsTableId: discountsTableId,
    );
  }

  @override
  Future<void> deletePartner(String partnerId) async {
    await _dataSource.deletePartner(partnerId);
  }

  @override
  Future<void> calculatePartnerDiscounts(
    String partnerId,
    String discountTableId,
  ) async {
    await _calculatorDataSource.calculateDiscount(partnerId, discountTableId);
  }

  @override
  Future<List<PartnerDiscountLogEntity>> getCalculationHistory(
    String partnerId,
  ) async {
    final models = await _dataSource.getCalculationHistory(partnerId);
    return models
        .map(
          (model) => PartnerDiscountLogEntity(
            id: model.id,
            partnerId: model.partnerId,
            discountTableId: model.discountTableId,
            tableNicknameStamp: model.tableNicknameStamp,
            partnerDailyPriceStamp: model.partnerDailyPriceStamp,
            partnerClientsAmountStamp: model.partnerClientsAmountStamp,
            totalPriceResult: model.totalPriceResult,
            totalDiscountResult: model.totalDiscountResult,
            totalPriceAfterDiscountResult: model.totalPriceAfterDiscountResult,
            calculationDate: model.calculationDate,
            discountRangesStamp: model.discountRangesStamp
                .map(
                  (range) => DiscountTableRangeEntity(
                    initialRange: range.initialRange,
                    finalRange: range.finalRange,
                    discount: range.discount,
                  ),
                )
                .toList(),
            details: model.details
                .map(
                  (detail) => PartnerDiscountLogDetailsEntity(
                    initialRange: detail.initialRange,
                    finalRange: detail.finalRange,
                    discount: detail.discount,
                    rangeTotalClientsAmount: detail.rangeTotalClientsAmount,
                    rangeTotalPrice: detail.rangeTotalPrice,
                    rangeTotalDiscount: detail.rangeTotalDiscount,
                    rangeTotalPriceAfterDiscount:
                        detail.rangeTotalPriceAfterDiscount,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }
}
