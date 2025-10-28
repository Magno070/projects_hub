// lib/features/progressive_discounts/data/repositories/discount_table_repository_impl.dart

import 'package:projects_hub/features/progressive_discounts/data/datasources/discounts_api_data_source.dart';
import 'package:projects_hub/features/progressive_discounts/data/models/discounts_table_model.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/repositories/discount_table_repository.dart';

class DiscountTableRepositoryImpl implements DiscountTableRepository {
  final DiscountsApiDataSource _dataSource;

  DiscountTableRepositoryImpl(this._dataSource);

  @override
  Future<void> createDiscountTable(DiscountTableEntity entity) async {
    await _dataSource.createDiscountTable(
      DiscountsTableModel(
        id: entity.id,
        nickname: entity.nickname,
        discountType: entity.discountType,
        ranges: entity.ranges
            .map(
              (range) => DiscountRange(
                initialRange: range.initialRange,
                finalRange: range.finalRange,
                discount: range.discount,
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Future<List<DiscountTableEntity>> getAllDiscountTables() async {
    final models = await _dataSource.getAllDiscountTables();
    return models
        .map(
          (model) => DiscountTableEntity(
            id: model.id,
            nickname: model.nickname,
            discountType: model.discountType,
            ranges: model.ranges
                .map(
                  (range) => DiscountTableRangeEntity(
                    initialRange: range.initialRange,
                    finalRange: range.finalRange,
                    discount: range.discount,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Future<DiscountTableEntity> getDiscountTable(String tableId) async {
    final model = await _dataSource.getDiscountTable(tableId);
    return DiscountTableEntity(
      id: model.id,
      nickname: model.nickname,
      discountType: model.discountType,
      ranges: model.ranges
          .map(
            (range) => DiscountTableRangeEntity(
              initialRange: range.initialRange,
              finalRange: range.finalRange,
              discount: range.discount,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<List<DiscountTableEntity>> getAllPersonalDiscountTables() async {
    final models = await _dataSource.getAllPersonalDiscountTables();
    return models
        .map(
          (model) => DiscountTableEntity(
            id: model.id,
            nickname: model.nickname,
            discountType: model.discountType,
            ranges: model.ranges
                .map(
                  (range) => DiscountTableRangeEntity(
                    initialRange: range.initialRange,
                    finalRange: range.finalRange,
                    discount: range.discount,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Future<DiscountTableEntity?> getBaseDiscountTable() async {
    try {
      final model = await _dataSource.getBaseDiscountTable();
      return DiscountTableEntity(
        id: model.id,
        nickname: model.nickname,
        discountType: model.discountType,
        ranges: model.ranges
            .map(
              (range) => DiscountTableRangeEntity(
                initialRange: range.initialRange,
                finalRange: range.finalRange,
                discount: range.discount,
              ),
            )
            .toList(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateDiscountTable({
    required String tableId,
    String? nickname,
    String? discountType,
    List<DiscountTableRangeEntity>? ranges,
  }) async {
    await _dataSource.updateDiscountTable(
      tableId: tableId,
      nickname: nickname,
      discountType: discountType,
      ranges: ranges
          ?.map(
            (range) => DiscountRange(
              initialRange: range.initialRange,
              finalRange: range.finalRange,
              discount: range.discount,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> deleteDiscountTable(String tableId) async {
    await _dataSource.deleteDiscountTable(tableId);
  }
}
