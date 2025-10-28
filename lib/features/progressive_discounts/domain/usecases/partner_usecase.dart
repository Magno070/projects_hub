import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/entities/partner_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/repositories/discount_table_repository.dart';
import 'package:projects_hub/features/progressive_discounts/domain/repositories/partner_repository.dart';

class UpdatePartnerClientsAmountUseCase {
  final PartnerRepository _repository;

  UpdatePartnerClientsAmountUseCase(this._repository);

  Future<void> call(String partnerId, int clientsAmount) async {
    final PartnerEntity? currentEntity = await _repository.getPartner(
      partnerId,
    );
    if (currentEntity == null) {
      throw Exception('Partner not found');
    }
    final PartnerEntity updatedEntity = currentEntity.copyWith(
      clientsAmount: clientsAmount,
    );
    await _repository.updatePartner(
      partnerId: partnerId,
      clientsAmount: updatedEntity.clientsAmount,
    );
  }
}

class UpdatePartnerDailyPriceUseCase {
  final PartnerRepository _repository;

  UpdatePartnerDailyPriceUseCase(this._repository);

  Future<void> call(String partnerId, double dailyPrice) async {
    if (dailyPrice <= 0) {
      throw ArgumentError(
        'O preço diário deve ser maior que zero. Valor recebido: $dailyPrice',
      );
    }

    final PartnerEntity? currentEntity = await _repository.getPartner(
      partnerId,
    );
    if (currentEntity == null) {
      throw Exception('Partner not found');
    }

    final PartnerEntity updatedEntity = currentEntity.copyWith(
      dailyPrice: dailyPrice,
    );

    await _repository.updatePartner(
      partnerId: partnerId,
      dailyPrice: updatedEntity.dailyPrice,
    );
  }
}

class UpdatePartnerDiscountsTableUseCase {
  final PartnerRepository _repository;
  final DiscountTableRepository _discountTableRepository;

  UpdatePartnerDiscountsTableUseCase(
    this._repository,
    this._discountTableRepository,
  );

  Future<void> call(String partnerId, String discountsTableId) async {
    final PartnerEntity? currentEntity = await _repository.getPartner(
      partnerId,
    );
    if (currentEntity == null) {
      throw Exception('Partner not found');
    }

    final DiscountTableEntity? discountsTableEntity =
        await _discountTableRepository.getDiscountTable(discountsTableId);

    if (discountsTableEntity == null) {
      throw Exception('Discount table not found');
    }

    final PartnerEntity updatedEntity = currentEntity.copyWith(
      discountsTableId: discountsTableId,
      discountType: discountsTableEntity.discountType,
    );
    await _repository.updatePartner(
      partnerId: partnerId,
      discountsTableId: updatedEntity.discountsTableId,
      discountType: updatedEntity.discountType,
    );
  }
}

class GetAllPartnersUseCase {
  final PartnerRepository _repository;

  GetAllPartnersUseCase(this._repository);

  Future<List<PartnerEntity>> call() async {
    return await _repository.getAllPartners();
  }
}

class DeletePartnerUseCase {
  final PartnerRepository _repository;

  DeletePartnerUseCase(this._repository);

  Future<void> call(String partnerId) async {
    await _repository.deletePartner(partnerId);
  }
}
