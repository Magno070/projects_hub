import 'package:projects_hub/features/progressive_discounts/domain/entities/discount_table_entity.dart';
import 'package:projects_hub/features/progressive_discounts/domain/repositories/discount_table_repository.dart';

class SplitDiscountTables {
  final DiscountTableEntity? baseDiscountTable;
  final List<DiscountTableEntity> customDiscountTables;

  SplitDiscountTables({
    this.baseDiscountTable,
    required this.customDiscountTables,
  });
}

class CloneDiscountTableUseCase {
  final DiscountTableRepository _repository;

  CloneDiscountTableUseCase(this._repository);

  Future<void> call(String tableId) async {
    final DiscountTableEntity? currentEntity = await _repository
        .getDiscountTable(tableId);

    if (currentEntity == null) {
      throw Exception('Discount table not found');
    }

    final DiscountTableEntity newEntity = currentEntity.copyWith(
      nickname: '${currentEntity.nickname} (Clone)',
      discountType: "personal",
    );
    await _repository.createDiscountTable(newEntity);
  }
}

class DeleteDiscountTableUseCase {
  final DiscountTableRepository _repository;

  DeleteDiscountTableUseCase(this._repository);

  Future<void> call(String tableId) async {
    await _repository.deleteDiscountTable(tableId);
  }
}

class UpdateDiscountNicknameUseCase {
  final DiscountTableRepository _repository;

  UpdateDiscountNicknameUseCase(this._repository);

  Future<void> call({
    required String tableId,
    required String newNickname,
  }) async {
    final DiscountTableEntity? currentEntity = await _repository
        .getDiscountTable(tableId);

    if (currentEntity == null) {
      throw Exception('Discount table not found');
    }

    final DiscountTableEntity updatedEntity = currentEntity.copyWith(
      nickname: newNickname,
    );
    await _repository.updateDiscountTable(
      tableId: tableId,
      nickname: updatedEntity.nickname,
    );
  }
}

class SetNewBaseDiscountTableUseCase {
  final DiscountTableRepository _repository;
  SetNewBaseDiscountTableUseCase(this._repository);

  Future<void> call(String newBaseEntityId) async {
    final DiscountTableEntity? newBaseEntity = await _repository
        .getDiscountTable(newBaseEntityId);

    if (newBaseEntity == null) {
      throw Exception('Discount table not found');
    }

    if (newBaseEntity.discountType == 'base') {
      return;
    }

    final DiscountTableEntity? currentEntity = await _repository
        .getBaseDiscountTable();

    final List<Future<void>> futures = [];

    if (currentEntity != null) {
      futures.add(
        _repository.updateDiscountTable(
          tableId: currentEntity.id,
          discountType: 'personal',
        ),
      );
    }

    futures.add(
      _repository.updateDiscountTable(
        tableId: newBaseEntity.id,
        discountType: 'base',
      ),
    );

    await Future.wait(futures);
  }
}

class GetAllDiscountTablesUseCase {
  final DiscountTableRepository _repository;

  GetAllDiscountTablesUseCase(this._repository);

  Future<SplitDiscountTables> call() async {
    final allTables = await _repository.getAllDiscountTables();

    DiscountTableEntity? baseTable;
    try {
      baseTable = allTables.firstWhere((table) => table.discountType == 'base');
    } catch (e) {
      baseTable = null;
    }

    final customTables = allTables
        .where((table) => table.discountType == 'personal')
        .toList();

    return SplitDiscountTables(
      baseDiscountTable: baseTable,
      customDiscountTables: customTables,
    );
  }
}

class GetDiscountTableUseCase {
  final DiscountTableRepository _repository;

  GetDiscountTableUseCase(this._repository);

  Future<DiscountTableEntity> call(String tableId) async {
    final DiscountTableEntity? table = await _repository.getDiscountTable(
      tableId,
    );
    if (table == null) {
      throw Exception('Discount table not found');
    }
    return table;
  }
}

class VerifyDiscountTableRangesUseCase {
  final DiscountTableRepository _repository;

  VerifyDiscountTableRangesUseCase(this._repository);

  Future<void> call(String tableId) async {
    final DiscountTableEntity? currentEntity = await _repository
        .getDiscountTable(tableId);

    if (currentEntity == null) {
      throw Exception('Discount table not found');
    }

    final List<DiscountTableRangeEntity> ranges = currentEntity.ranges;

    // Verifica se há pelo menos um range
    if (ranges.isEmpty) {
      throw ArgumentError('A tabela de descontos deve ter pelo menos um range');
    }

    // Ordena os ranges por initialRange para facilitar a verificação
    final sortedRanges = List<DiscountTableRangeEntity>.from(ranges);
    sortedRanges.sort((a, b) => a.initialRange.compareTo(b.initialRange));

    // 1. Verifica se o primeiro range começa em 1
    if (sortedRanges.first.initialRange != 1) {
      throw ArgumentError('A primeira faixa de desconto deve começar em 1');
    }

    // 2. Verifica se cada range tem initialRange < finalRange
    for (var range in sortedRanges) {
      if (range.initialRange >= range.finalRange) {
        throw ArgumentError(
          'A faixa de desconto inicial deve ser menor que a faixa de desconto final',
        );
      }
    }

    // 3. Verifica se não há sobreposição entre ranges
    for (int i = 0; i < sortedRanges.length - 1; i++) {
      final currentRange = sortedRanges[i];
      final nextRange = sortedRanges[i + 1];

      if (currentRange.finalRange >= nextRange.initialRange) {
        throw ArgumentError('As faixas de desconto não podem se sobrepor');
      }
    }

    // 4. Verifica se todos os números de 1 até o finalRange do último range estão cobertos
    final lastRange = sortedRanges.last;
    final expectedNumbers = List.generate(
      lastRange.finalRange,
      (index) => index + 1,
    );

    final coveredNumbers = <int>{};
    for (var range in sortedRanges) {
      for (int i = range.initialRange; i <= range.finalRange; i++) {
        coveredNumbers.add(i);
      }
    }

    final missingNumbers = expectedNumbers
        .where((number) => !coveredNumbers.contains(number))
        .toList();

    if (missingNumbers.isNotEmpty) {
      throw ArgumentError(
        'Existem números não cobertos pelos ranges: ${missingNumbers.join(', ')}',
      );
    }

    // 5. Verifica se não há números extras além do esperado
    final extraNumbers = coveredNumbers
        .where((number) => number > lastRange.finalRange)
        .toList();

    if (extraNumbers.isNotEmpty) {
      throw ArgumentError(
        'Existem números extras além do range máximo: ${extraNumbers.join(', ')}',
      );
    }
  }
}
