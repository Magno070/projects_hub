import 'dart:convert';

import 'package:projects_hub/core/api/api_client.dart';
import 'package:projects_hub/core/api/api_constants.dart';
import 'package:projects_hub/features/progressive_discounts/data/datasources/partner_api_data_source.dart';
import 'package:projects_hub/features/progressive_discounts/data/models/partner_model.dart';

class PartnerApiDataSourceImpl implements PartnerApiDataSource {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiConstants.partner);

  @override
  Future<void> createPartner(PartnerModel model) async {
    try {
      final data = model.toJson();
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
      final responseJson = await _apiClient.get('/$partnerId');
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
  Future<void> updatePartner({
    required String partnerId,
    String? name,
    String? discountType,
    double? dailyPrice,
    int? clientsAmount,
    String? discountsTableId,
  }) async {
    try {
      await _apiClient.patch('/$partnerId', {
        'name': name,
        'discountType': discountType,
        'dailyPrice': dailyPrice,
        'clientsAmount': clientsAmount,
        'discountsTableId': discountsTableId,
      });
    } catch (e) {
      throw Exception('Failed to update partner: $e');
    }
  }

  @override
  Future<void> deletePartner(String partnerId) async {
    try {
      await _apiClient.delete('/$partnerId');
    } catch (e) {
      throw Exception('Failed to delete partner: $e');
    }
  }
}
