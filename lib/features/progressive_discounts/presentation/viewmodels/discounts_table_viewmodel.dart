import 'package:projects_hub/core/base/base_viewmodel.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/usecases/discounts_table_usecase.dart';

/// ViewModel para gerenciar o estado da tabela de descontos
/// Segue o padrão MVVM separando a lógica de apresentação da UI
class DiscountsTableViewModel extends BaseViewModel {
  final UpdateDiscountNicknameUseCase _updateNicknameUseCase;
  final GetDiscountTableUseCase _getDiscountTableUseCase;

  DiscountsTableViewModel({
    required UpdateDiscountNicknameUseCase updateNicknameUseCase,
    required GetDiscountTableUseCase getDiscountTableUseCase,
  }) : _updateNicknameUseCase = updateNicknameUseCase,
       _getDiscountTableUseCase = getDiscountTableUseCase;

  DiscountTableEntity? _discountTable;
  String? _currentTableId;

  /// Tabela de desconto atual
  DiscountTableEntity? get discountTable => _discountTable;

  /// ID da tabela atual
  String? get currentTableId => _currentTableId;

  /// Indica se há dados carregados
  bool get hasData => _discountTable != null;

  /// Carrega uma tabela de desconto pelo ID
  Future<void> loadDiscountTable(String tableId) async {
    _currentTableId = tableId;
    
    await executeWithLoading(() async {
      _discountTable = await _getDiscountTableUseCase(tableId);
    });
  }

  /// Atualiza o nickname da tabela de desconto
  Future<void> updateNickname(String newNickname) async {
    if (_currentTableId == null) {
      setError('Nenhuma tabela selecionada');
      return;
    }

    await executeWithLoading(() async {
      await _updateNicknameUseCase.call(
        tableId: _currentTableId!,
        newNickname: newNickname,
      );
      
      // Recarrega os dados após a atualização
      await loadDiscountTable(_currentTableId!);
    });
  }

  /// Adiciona uma nova faixa de desconto
  Future<void> addDiscountRange({
    required int initialRange,
    required int finalRange,
    required double discount,
  }) async {
    if (_discountTable == null) return;

    final newRange = DiscountTableRangeEntity(
      initialRange: initialRange,
      finalRange: finalRange,
      discount: discount,
    );

    final updatedRanges = List<DiscountTableRangeEntity>.from(_discountTable!.discountRanges)
      ..add(newRange);

    _discountTable = _discountTable!.copyWith(discountRanges: updatedRanges);
    notifyListeners();
  }

  /// Remove uma faixa de desconto pelo índice
  Future<void> removeDiscountRange(int index) async {
    if (_discountTable == null || index < 0 || index >= _discountTable!.discountRanges.length) {
      return;
    }

    final updatedRanges = List<DiscountTableRangeEntity>.from(_discountTable!.discountRanges)
      ..removeAt(index);

    _discountTable = _discountTable!.copyWith(discountRanges: updatedRanges);
    notifyListeners();
  }

  /// Atualiza uma faixa de desconto existente
  Future<void> updateDiscountRange({
    required int index,
    required int initialRange,
    required int finalRange,
    required double discount,
  }) async {
    if (_discountTable == null || index < 0 || index >= _discountTable!.discountRanges.length) {
      return;
    }

    final updatedRange = DiscountTableRangeEntity(
      initialRange: initialRange,
      finalRange: finalRange,
      discount: discount,
    );

    final updatedRanges = List<DiscountTableRangeEntity>.from(_discountTable!.discountRanges);
    updatedRanges[index] = updatedRange;

    _discountTable = _discountTable!.copyWith(discountRanges: updatedRanges);
    notifyListeners();
  }

  /// Calcula o total de descontos para uma faixa específica
  double calculateTotalForRange(DiscountTableRangeEntity range) {
    return range.discount * (range.finalRange - range.initialRange + 1);
  }

  /// Calcula o total geral de todos os descontos
  double calculateTotalDiscounts() {
    if (_discountTable == null) return 0.0;
    
    return _discountTable!.discountRanges
        .map((range) => calculateTotalForRange(range))
        .fold(0.0, (sum, total) => sum + total);
  }

  /// Valida se os dados da tabela estão corretos
  bool validateTableData() {
    if (_discountTable == null) return false;
    
    for (final range in _discountTable!.discountRanges) {
      if (range.initialRange >= range.finalRange) return false;
      if (range.discount < 0 || range.discount > 100) return false;
    }
    
    return true;
  }

  /// Limpa os dados atuais
  void clearData() {
    _discountTable = null;
    _currentTableId = null;
    clearError();
    notifyListeners();
  }
}