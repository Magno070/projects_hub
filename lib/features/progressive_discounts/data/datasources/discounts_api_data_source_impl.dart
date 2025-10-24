import 'dart:convert';

import 'package:projects_hub/features/progressive_discounts/data/datasources/discounts_api_data_source.dart';
import 'package:projects_hub/features/progressive_discounts/data/models/discounts_table_model.dart';
import 'package:projects_hub/core/api/api_client.dart';
import 'package:projects_hub/core/api/api_constants.dart';

class DiscountsApiDataSourceImpl implements DiscountsApiDataSource {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiConstants.discountTables);

  @override
  Future<void> createDiscountTable(DiscountsTableModel model) async {
    try {
      final data = model.toJson();
      await _apiClient.post('/', data);
    } catch (e) {
      throw Exception('Failed to create discount table: $e');
    }
  }

  @override
  Future<List<DiscountsTableModel>> getAllDiscountTables() async {
    try {
      final responseJson = await _apiClient.get('/all');
      return (jsonDecode(responseJson) as List)
          .map((json) => DiscountsTableModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all discount tables: $e');
    }
  }

  @override
  Future<DiscountsTableModel> getDiscountTable(String tableId) async {
    try {
      final responseJson = await _apiClient.get('/$tableId');
      return DiscountsTableModel.fromJson(jsonDecode(responseJson));
    } catch (e) {
      throw Exception('Failed to get discount table: $e');
    }
  }

  @override
  Future<void> updateDiscountTable(
    String tableId,
    String? nickname,
    String? discountType,
    List<DiscountRange>? discountRanges,
  ) async {
    try {
      await _apiClient.patch('/$tableId', {
        'nickname': nickname,
        'discountType': discountType,
        'discountRanges': discountRanges,
      });
    } catch (e) {
      throw Exception('Failed to save discount table: $e');
    }
  }

  @override
  Future<void> deleteDiscountTable(String tableId) async {
    try {
      await _apiClient.delete('/$tableId');
    } catch (e) {
      throw Exception('Failed to delete discount table: $e');
    }
  }
}
