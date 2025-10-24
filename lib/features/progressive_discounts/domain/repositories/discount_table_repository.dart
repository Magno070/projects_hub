import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';

abstract class DiscountTableRepository {
  Future<void> createDiscountTable(DiscountTableEntity entity);

  Future<List<DiscountTableEntity>> getAllDiscountTables();

  Future<DiscountTableEntity> getDiscountTable(String tableId);

  Future<void> updateDiscountTable(
    String tableId,
    String? nickname,
    String? discountType,
    List<DiscountTableRangeEntity>? ranges,
  );
}
