import 'package:flutter/material.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/usecases/discounts_table_usecase.dart';

class DiscountsTableNotifier extends ChangeNotifier {
  final UpdateDiscountNicknameUseCase _updateNicknameUseCase;
  final GetDiscountTableUseCase _getDiscountTableUseCase;

  DiscountsTableNotifier({
    required UpdateDiscountNicknameUseCase updateNicknameUseCase,
    required GetDiscountTableUseCase getDiscountTableUseCase,
  }) : _updateNicknameUseCase = updateNicknameUseCase,
       _getDiscountTableUseCase = getDiscountTableUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DiscountTableEntity? _discountTable;
  DiscountTableEntity? get discountTable => _discountTable;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDiscountTable(String tableId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _discountTable = await _getDiscountTableUseCase(tableId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateNickname(String tableId, String newNickname) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _updateNicknameUseCase.call(
        tableId: tableId,
        newNickname: newNickname,
      );

      await fetchDiscountTable(tableId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
