// domain/usecases/update_nickname_usecase.dart
import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/repositories/discount_table_repository.dart';

class UpdateDiscountNicknameUseCase {
  final DiscountTableRepository _repository;

  UpdateDiscountNicknameUseCase(this._repository);

  Future<void> call({
    required String tableId,
    required String newNickname,
  }) async {
    DiscountTableEntity currentEntity = await _repository.getDiscountTable(
      tableId,
    );

    DiscountTableEntity updatedEntity = currentEntity.copyWith(
      nickname: newNickname,
    );

    await _repository.updateDiscountTable(
      tableId,
      updatedEntity.nickname,
      updatedEntity.discountType,
      updatedEntity.ranges,
    );
  }
}

class GetDiscountTableUseCase {
  final DiscountTableRepository _repository;

  GetDiscountTableUseCase(this._repository);

  Future<DiscountTableEntity> call(String tableId) async {
    return await _repository.getDiscountTable(tableId);
  }
}
