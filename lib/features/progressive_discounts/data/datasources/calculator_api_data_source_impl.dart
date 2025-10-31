import 'package:projects_hub/core/api/api_client.dart';
import 'package:projects_hub/core/api/api_constants.dart';
import 'package:projects_hub/features/progressive_discounts/data/datasources/calculator_api_data_source.dart';

class CalculatorApiDataSourceImpl implements CalculatorApiDataSource {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiConstants.calculator);

  @override
  Future<void> calculateDiscount(
    String partnerId,
    String discountTableId,
  ) async {
    await _apiClient.post('/calculate-partner-discounts', {
      'partnerId': partnerId,
      'discountTableId': discountTableId,
    });
  }
}
