import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';

abstract class DiscountTableRepository {
  //Create
  Future<void> createDiscountTable(DiscountTableEntity entity);

  //Read
  Future<List<DiscountTableEntity>> getAllDiscountTables();

  Future<DiscountTableEntity> getDiscountTable(String tableId);

  Future<List<DiscountTableEntity>> getAllPersonalDiscountTables();

  Future<DiscountTableEntity> getBaseDiscountTable();

  //Update
  Future<void> updateDiscountTable({
    required String tableId,
    String? nickname,
    String? discountType,
    List<DiscountTableRangeEntity>? ranges,
  });

  //Delete
  Future<void> deleteDiscountTable(String tableId);
}
