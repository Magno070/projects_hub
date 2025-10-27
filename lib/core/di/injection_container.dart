import 'package:get_it/get_it.dart';

import 'package:projects_hub/features/progressive_discounts/data/datasources/discounts_api_data_source_impl.dart';
import 'package:projects_hub/features/progressive_discounts/data/datasources/discounts_api_data_source.dart';
import 'package:projects_hub/features/progressive_discounts/data/repositories/discount_table_repository_impl.dart';
import 'package:projects_hub/features/progressive_discounts/domain/repositories/discount_table_repository.dart';
import 'package:projects_hub/features/progressive_discounts/domain/usecases/discounts_table_usecase.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/progressive_discounts_viewmodel.dart';

/// Container de injeção de dependência para MVVM
/// Centraliza o registro de todas as dependências do projeto
final GetIt getIt = GetIt.instance;

/// Configura todas as dependências do projeto
Future<void> configureDependencies() async {
  // Data Sources
  getIt.registerLazySingleton<DiscountsApiDataSource>(
    () => DiscountsApiDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<DiscountTableRepository>(
    () => DiscountTableRepositoryImpl(getIt<DiscountsApiDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetDiscountTableUseCase>(
    () => GetDiscountTableUseCase(getIt<DiscountTableRepository>()),
  );

  getIt.registerLazySingleton<GetAllDiscountTablesUseCase>(
    () => GetAllDiscountTablesUseCase(getIt<DiscountTableRepository>()),
  );

  getIt.registerLazySingleton<UpdateDiscountNicknameUseCase>(
    () => UpdateDiscountNicknameUseCase(getIt<DiscountTableRepository>()),
  );

  getIt.registerLazySingleton<CloneDiscountTableUseCase>(
    () => CloneDiscountTableUseCase(getIt<DiscountTableRepository>()),
  );

  getIt.registerLazySingleton<DeleteDiscountTableUseCase>(
    () => DeleteDiscountTableUseCase(getIt<DiscountTableRepository>()),
  );

  getIt.registerLazySingleton<SetNewBaseDiscountTableUseCase>(
    () => SetNewBaseDiscountTableUseCase(getIt<DiscountTableRepository>()),
  );

  // ViewModels
  getIt.registerFactory<ProgressiveDiscountsViewModel>(
    () => ProgressiveDiscountsViewModel(
      getIt<GetAllDiscountTablesUseCase>(),
      getIt<UpdateDiscountNicknameUseCase>(),
      getIt<CloneDiscountTableUseCase>(),
      getIt<DeleteDiscountTableUseCase>(),
      getIt<SetNewBaseDiscountTableUseCase>(),
    ),
  );
}

/// Resolve uma dependência do tipo especificado
T get<T extends Object>() => getIt.get<T>();

/// Resolve uma dependência do tipo especificado com parâmetros nomeados
T getWithParam<T extends Object, P extends Object>(P param) =>
    getIt.get<T>(param1: param);
