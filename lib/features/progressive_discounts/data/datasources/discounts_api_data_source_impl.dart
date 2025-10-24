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
      final responseString = await _apiClient.get('/$tableId');

      final responseJson = jsonDecode(responseString);

      final success = responseJson['success'];

      if (success) {
        final discountTableData = responseJson['data']['discountTable'];

        // Mapeia 'ranges' para 'discountRanges' para compatibilidade com o modelo
        // final mappedData = {
        //   '_id': discountTableData['_id'],
        //   'nickname': discountTableData['nickname'],
        //   'discountType': discountTableData['discountType'],
        //   'discountRanges':
        //       discountTableData['ranges'], // Mapeia 'ranges' para 'discountRanges'
        // };

        return DiscountsTableModel.fromJson(discountTableData);
      } else {
        throw Exception(
          'API returned unsuccessful response: ${responseJson['message']}',
        );
      }
    } catch (e) {
      throw Exception('Failed to get discount table: $e');
    }
  }

  @override
  Future<void> updateDiscountTable(
    String tableId,
    String? nickname,
    String? discountType,
    List<DiscountRange>? ranges,
  ) async {
    try {
      await _apiClient.patch('/$tableId', {
        'nickname': nickname,
        'discountType': discountType,
        'ranges': ranges,
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
