import 'package:projects_hub/features/progressive_discounts/data/models/discounts_table_model.dart';

abstract class DiscountsApiDataSource {
  Future<void> createDiscountTable(DiscountsTableModel model);

  Future<List<DiscountsTableModel>> getAllDiscountTables();

  Future<DiscountsTableModel> getDiscountTable(String tableId);

  Future<List<DiscountsTableModel>> getAllPersonalDiscountTables();

  Future<DiscountsTableModel> getBaseDiscountTable();

  Future<void> updateDiscountTable({
    required String tableId,
    String? nickname,
    String? discountType,
    List<DiscountRange>? ranges,
  });

  Future<void> deleteDiscountTable(String tableId);
}
