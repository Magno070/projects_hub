import 'package:projects_hub/core/base/base_viewmodel.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/usecases/discounts_table_usecase.dart';
import 'package:projects_hub/features/progressive_discounts/domain/usecases/partner_usecase.dart';

class PartnersViewModel extends BaseViewModel {
  final GetAllPartnersUseCase _getAllPartnersUseCase;
  final GetAllDiscountTablesUseCase _getAllTablesUseCase;
  final UpdatePartnerClientsAmountUseCase _updateClientsAmountUseCase;
  final UpdatePartnerDailyPriceUseCase _updateDailyPriceUseCase;
  final UpdatePartnerDiscountsTableUseCase _updateTableUseCase;
  final DeletePartnerUseCase _deletePartnerUseCase;

  PartnersViewModel(
    this._getAllPartnersUseCase,
    this._getAllTablesUseCase,
    this._updateClientsAmountUseCase,
    this._updateDailyPriceUseCase,
    this._updateTableUseCase,
    this._deletePartnerUseCase,
  );

  List<PartnerEntity> _partners = [];
  List<DiscountTableEntity> _allTables = [];

  List<PartnerEntity> get partners => _partners;
  List<DiscountTableEntity> get allTables => _allTables;

  Future<void> loadData() async {
    await executeWithLoading(() async {
      // Carrega parceiros e tabelas em paralelo
      final results = await Future.wait([
        _getAllPartnersUseCase.call(),
        _getAllTablesUseCase.call(),
      ]);

      _partners = results[0] as List<PartnerEntity>;
      final splitTables = results[1] as SplitDiscountTables;

      // Combina tabelas base e personalizadas para o dropdown
      _allTables = [
        if (splitTables.baseDiscountTable != null)
          splitTables.baseDiscountTable!,
        ...splitTables.customDiscountTables,
      ];

      notifyListeners();
    });
  }

  Future<void> updateClientsAmount(String partnerId, int clientsAmount) async {
    // Não executa com loading para uma atualização mais suave
    try {
      await _updateClientsAmountUseCase.call(partnerId, clientsAmount);
      // Atualiza o estado local
      final index = _partners.indexWhere((p) => p.id == partnerId);
      if (index != -1) {
        _partners[index] = _partners[index].copyWith(
          clientsAmount: clientsAmount,
        );
        notifyListeners();
      }
    } catch (e) {
      setError(e.toString());
      loadData(); // Recarrega em caso de erro
    }
  }

  Future<void> updateDailyPrice(String partnerId, double dailyPrice) async {
    try {
      await _updateDailyPriceUseCase.call(partnerId, dailyPrice);
      // Atualiza o estado local
      final index = _partners.indexWhere((p) => p.id == partnerId);
      if (index != -1) {
        _partners[index] = _partners[index].copyWith(dailyPrice: dailyPrice);
        notifyListeners();
      }
    } catch (e) {
      setError(e.toString());
      loadData(); // Recarrega em caso de erro
    }
  }

  Future<void> updateDiscountTable(String partnerId, String tableId) async {
    await executeWithLoading(() async {
      await _updateTableUseCase.call(partnerId, tableId);
      // Recarrega todos os dados após a mudança da tabela
      await loadData();
    });
  }

  Future<void> deletePartner(String partnerId) async {
    await executeWithLoading(() async {
      await _deletePartnerUseCase.call(partnerId);
      // Remove da lista local
      _partners.removeWhere((p) => p.id == partnerId);
      notifyListeners();
    });
  }
}
