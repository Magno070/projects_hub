import 'dart:convert';

import 'package:projects_hub/core/api/api_client.dart';
import 'package:projects_hub/core/api/api_constants.dart';
import 'package:projects_hub/features/progressive_discounts/data/datasources/partner_api_data_source.dart';
import 'package:projects_hub/features/progressive_discounts/data/models/partner_discount_log.dart';
import 'package:projects_hub/features/progressive_discounts/data/models/partner_model.dart';

class PartnerApiDataSourceImpl implements PartnerApiDataSource {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiConstants.partner);

  @override
  Future<void> createPartner(PartnerModel model) async {
    try {
      final data = model.toJsonForCreation();

      await _apiClient.post('/', data);
    } catch (e) {
      throw Exception('Failed to create partner: $e');
    }
  }

  @override
  Future<List<PartnerModel>> getAllPartners() async {
    try {
      final responseJson = await _apiClient.get('/all');
      final response = jsonDecode(responseJson);

      if (response['success'] == false) {
        return [];
      }

      if (response['partners'] == null) {
        return [];
      }
      return (response['partners'] as List)
          .map((json) => PartnerModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all partners: $e');
    }
  }

  @override
  Future<PartnerModel?> getPartner(String partnerId) async {
    try {
      final responseJson = await _apiClient.get(
        '/',
        queryParams: {'id': partnerId},
      );
      final response = jsonDecode(responseJson);
      if (response['success'] == false) {
        return null;
      }
      if (response['partner'] == null) {
        return null;
      }
      return PartnerModel.fromJson(response['partner']);
    } catch (e) {
      throw Exception('Failed to get partner: $e');
    }
  }

  @override
  Future<List<PartnerDiscountLogModel>> getCalculationHistory(
    String partnerId,
  ) async {
    try {
      final responseJson = await _apiClient.get(
        '/logs',
        queryParams: {'id': partnerId},
      );
      final response = jsonDecode(responseJson);
      if (response['success'] == false) {
        return [];
      }
      if (response['calculationLog'] == null) {
        return [];
      }
      return (response['calculationLog'] as List)
          .map((json) => PartnerDiscountLogModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get calculation history: $e');
    }
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
    try {
      await _apiClient.patch(
        '/',
        queryParams: {'id': partnerId},
        {
          'name': name,
          'discountType': discountType,
          'dailyPrice': dailyPrice,
          'clientsAmount': clientsAmount,
          'discountsTableId': discountsTableId,
        },
      );
    } catch (e) {
      throw Exception('Failed to update partner: $e');
    }
  }

  @override
  Future<void> deletePartner(String partnerId) async {
    try {
      await _apiClient.delete('/', queryParams: {'id': partnerId});
    } catch (e) {
      throw Exception('Failed to delete partner: $e');
    }
  }
}
