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

  DiscountTableEntity? _baseDiscountTable;
  List<DiscountTableEntity> _customDiscountTables = [];

  DiscountTableEntity? get baseDiscountTable => _baseDiscountTable;
  List<DiscountTableEntity> get customDiscountTables => _customDiscountTables;

  Future<void> loadDiscountTables() async {
    await executeWithLoading(() async {
      final SplitDiscountTables splitTables = await _getAllTablesUseCase.call();

      _baseDiscountTable = splitTables.baseDiscountTable;
      _customDiscountTables = splitTables.customDiscountTables;

      notifyListeners();
    });
  }

  Future<void> updateNickname(String id, String nickname) async {
    await executeWithLoading(() async {
      await _updateNicknameUseCase.call(tableId: id, newNickname: nickname);
    });

    if (errorMessage == null) {
      loadDiscountTables();
    }
  }

  Future<void> cloneTable(String id) async {
    await executeWithLoading(() async {
      await _cloneTableUseCase.call(id);
    });

    if (errorMessage == null) {
      loadDiscountTables();
    }
  }

  Future<void> deleteTable(String id) async {
    await executeWithLoading(() async {
      await _deleteTableUseCase.call(id);
    });

    if (errorMessage == null) {
      loadDiscountTables();
    }
  }

  Future<void> setAsBase(String id) async {
    await executeWithLoading(() async {
      await _setAsBaseUseCase.call(id);
    });

    if (errorMessage == null) {
      loadDiscountTables();
    }
  }
}
