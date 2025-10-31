import 'package:flutter/material.dart';
import 'package:projects_hub/core/base/base_viewmodel.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_discount_log_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/usecases/discounts_table_usecase.dart';
import 'package:projects_hub/features/progressive_discounts/domain/usecases/partner_usecase.dart';

class PartnersViewModel extends BaseViewModel {
  final GetAllPartnersUseCase _getAllPartnersUseCase;
  final GetAllDiscountTablesUseCase _getAllTablesUseCase;
  final GetPartnerUseCase _getPartnerUseCase;
  final UpdatePartnerClientsAmountUseCase _updateClientsAmountUseCase;
  final UpdatePartnerDailyPriceUseCase _updateDailyPriceUseCase;
  final UpdatePartnerDiscountsTableUseCase _updateTableUseCase;
  final DeletePartnerUseCase _deletePartnerUseCase;
  final CreatePartnerUseCase _createPartnerUseCase;
  final CalculatePartnerDiscountsUseCase _calculateDiscountsUseCase;
  final GetCalculationHistoryUseCase _getCalculationHistoryUseCase;

  PartnersViewModel(
    this._getAllPartnersUseCase,
    this._getAllTablesUseCase,
    this._getPartnerUseCase,
    this._updateClientsAmountUseCase,
    this._updateDailyPriceUseCase,
    this._updateTableUseCase,
    this._deletePartnerUseCase,
    this._createPartnerUseCase,
    this._calculateDiscountsUseCase,
    this._getCalculationHistoryUseCase,
  );

  List<PartnerEntity> _partners = [];
  List<DiscountTableEntity> _allTables = [];
  List<PartnerDiscountLogEntity> _calculationHistory = [];
  String? _selectedPartnerId;

  List<PartnerEntity> get partners => _partners;
  List<DiscountTableEntity> get allTables => _allTables;
  String? get selectedPartnerId => _selectedPartnerId;
  List<PartnerDiscountLogEntity> get calculationHistory => _calculationHistory;

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

  void selectPartner(String partnerId) {
    if (_selectedPartnerId == partnerId) {
      _selectedPartnerId = null;
    } else {
      _selectedPartnerId = partnerId;
    }
    notifyListeners();
  }

  Future<PartnerEntity?> getPartner(String partnerId) async {
    PartnerEntity? partner;
    await executeWithLoading(() async {
      partner = await _getPartnerUseCase.call(partnerId);
      if (partner != null) {
        _selectedPartnerId = partner!.id;
      }
    });
    return partner;
  }

  Future<bool> createPartner({
    required String name,
    required double dailyPrice,
    required int clientsAmount,
    required String discountsTableId,
  }) async {
    try {
      final success = await executeWithLoading(() async {
        await _createPartnerUseCase.call(
          name: name,
          dailyPrice: dailyPrice,
          clientsAmount: clientsAmount,
          discountsTableId: discountsTableId,
        );
      });

      await loadData();

      return true;
    } catch (e) {
      debugPrint("Erro ao criar parceiro: $e");
      setError(e.toString());
      return false;
    }
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
      debugPrint("Erro ao atualizar quantidade de clientes: $e");
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
      debugPrint("Erro ao atualizar preço diário: $e");
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

      if (_selectedPartnerId == partnerId) {
        _selectedPartnerId = null;
      }

      notifyListeners();
    });
  }

  Future<void> calculateDiscounts(
    String partnerId,
    String discountTableId,
  ) async {
    await executeWithLoading(() async {
      await _calculateDiscountsUseCase.call(partnerId, discountTableId);
      await getCalculationHistory(partnerId);
    });
  }

  Future<void> getCalculationHistory(String partnerId) async {
    await executeWithLoading(() async {
      _calculationHistory = await _getCalculationHistoryUseCase.call(partnerId);
      notifyListeners();
    });
  }
}
