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
      // Usa toJsonForCreation() para não enviar o campo 'id' na criação
      final data = model.toJsonForCreation();
      await _apiClient.post('/', data);
    } catch (e) {
      throw Exception('Failed to create discount table: $e');
    }
  }

  @override
  Future<List<DiscountsTableModel>> getAllDiscountTables() async {
    try {
      final responseString = await _apiClient.get('/all');
      final discountTables =
          (jsonDecode(responseString)["discountTables"] as List<dynamic>);
      return discountTables
          .map((e) => DiscountsTableModel.fromJson(e))
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
  Future<List<DiscountsTableModel>> getAllPersonalDiscountTables() async {
    try {
      final responseString = await _apiClient.get('/personal');
      final discountTables =
          (jsonDecode(responseString)["discountTables"] as List<dynamic>);
      return discountTables
          .map((e) => DiscountsTableModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all personal discount tables: $e');
    }
  }

  @override
  Future<DiscountsTableModel> getBaseDiscountTable() async {
    try {
      final responseString = await _apiClient.get('/base');
      final responseJson = jsonDecode(responseString);

      if (responseJson['success'] == false) {
        throw Exception('No base discount table found');
      }

      final discountTable = DiscountsTableModel.fromJson(
        responseJson["baseDiscountTable"],
      );
      return discountTable;
    } catch (e) {
      throw Exception('Failed to get base discount table: $e');
    }
  }

  @override
  Future<void> updateDiscountTable({
    required String tableId,
    String? nickname,
    String? discountType,
    List<DiscountRange>? ranges,
  }) async {
    try {
      final response = await _apiClient.patch('/$tableId', {
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
