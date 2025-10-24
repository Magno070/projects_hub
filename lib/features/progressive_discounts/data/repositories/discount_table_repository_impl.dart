// lib/features/progressive_discounts/data/repositories/discount_table_repository_impl.dart

import 'package:projects_hub/features/progressive_discounts/data/datasources/discounts_api_data_source.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/repositories/discount_table_repository.dart';

class DiscountTableRepositoryImpl implements DiscountTableRepository {
  final DiscountsApiDataSource _dataSource;

  DiscountTableRepositoryImpl(this._dataSource);

  @override
  Future<void> createDiscountTable(DiscountTableEntity entity) async {
    await _dataSource.createDiscountTable(entity.toModel());
  }

  @override
  Future<List<DiscountTableEntity>> getAllDiscountTables() async {
    final models = await _dataSource.getAllDiscountTables();
    return models.map((model) => DiscountTableEntity.fromModel(model)).toList();
  }

  @override
  Future<DiscountTableEntity> getDiscountTable(String tableId) async {
    final model = await _dataSource.getDiscountTable(tableId);
    return DiscountTableEntity.fromModel(model);
  }

  @override
  Future<void> updateDiscountTable(
    String tableId,
    String? nickname,
    String? discountType,
    List<DiscountTableRangeEntity>? ranges,
  ) async {
    await _dataSource.updateDiscountTable(
      tableId,
      nickname,
      discountType,
      ranges?.map((range) => range.toModel()).toList(),
    );
  }
}
