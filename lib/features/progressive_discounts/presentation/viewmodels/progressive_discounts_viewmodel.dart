import 'package:projects_hub/core/base/base_viewmodel.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/usecases/discounts_table_usecase.dart';

class ProgressiveDiscountsViewModel extends BaseViewModel {
  final GetAllDiscountTablesUseCase _getAllTablesUseCase;
  final UpdateDiscountNicknameUseCase _updateNicknameUseCase;
  final CloneDiscountTableUseCase _cloneTableUseCase;
  final DeleteDiscountTableUseCase _deleteTableUseCase;
  final SetNewBaseDiscountTableUseCase _setAsBaseUseCase;

  ProgressiveDiscountsViewModel(
    this._getAllTablesUseCase,
    this._updateNicknameUseCase,
    this._cloneTableUseCase,
    this._deleteTableUseCase,
    this._setAsBaseUseCase,
  );

  List<DiscountTableEntity> _allDiscountTables = [];

  DiscountTableEntity? _baseDiscountTable;
  List<DiscountTableEntity> _customDiscountTables = [];

  DiscountTableEntity? get baseDiscountTable => _baseDiscountTable;
  List<DiscountTableEntity> get customDiscountTables => _customDiscountTables;

  List<DiscountTableEntity> get discountTables => _allDiscountTables;

  Future<void> loadDiscountTables() async {
    await executeWithLoading(() async {
      _allDiscountTables = await _getAllTablesUseCase.call();

      try {
        _baseDiscountTable = _allDiscountTables.firstWhere(
          (table) => table.discountType == 'base',
        );
      } catch (e) {
        _baseDiscountTable = null;
      }

      _customDiscountTables = _allDiscountTables
          .where((table) => table.discountType == 'personal')
          .toList();
      notifyListeners();
    });
  }

  Future<void> updateNickname(String id, String nickname) async {
    final result = await executeWithLoading(() async {
      await _updateNicknameUseCase.call(tableId: id, newNickname: nickname);
    });

    if (result != null) {
      loadDiscountTables();
    }
  }

  Future<void> cloneTable(String id) async {
    final result = await executeWithLoading(() async {
      await _cloneTableUseCase.call(id);
    });

    if (result != null) {
      // Sucesso - recarrega a lista
      loadDiscountTables();
    }
  }

  Future<void> deleteTable(String id) async {
    final result = await executeWithLoading(() async {
      await _deleteTableUseCase.call(id);
    });

    if (result != null) {
      // Sucesso - recarrega a lista
      loadDiscountTables();
    }
  }

  Future<void> setAsBase(String id) async {
    final result = await executeWithLoading(() async {
      await _setAsBaseUseCase.call(id);
    });

    if (result != null) {
      // Sucesso - recarrega a lista
      loadDiscountTables();
    }
  }
}
