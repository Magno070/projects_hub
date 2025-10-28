import 'package:get_it/get_it.dart';

import 'package:projects_hub/features/progressive_discounts/data/datasources/discounts_api_data_source_impl.dart';
import 'package:projects_hub/features/progressive_discounts/data/datasources/discounts_api_data_source.dart';
import 'package:projects_hub/features/progressive_discounts/data/repositories/discount_table_repository_impl.dart';
import 'package:projects_hub/features/progressive_discounts/domain/repositories/discount_table_repository.dart';
import 'package:projects_hub/features/progressive_discounts/domain/usecases/discounts_table_usecase.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/progressive_discounts_viewmodel.dart';

import 'package:projects_hub/features/progressive_discounts/data/datasources/partner_api_data_source.dart';
import 'package:projects_hub/features/progressive_discounts/data/datasources/partner_api_data_source_impl.dart';
import 'package:projects_hub/features/progressive_discounts/data/repositories/partner_repository_impl.dart';
import 'package:projects_hub/features/progressive_discounts/domain/repositories/partner_repository.dart';
import 'package:projects_hub/features/progressive_discounts/domain/usecases/partner_usecase.dart';
import 'package:projects_hub/features/progressive_discounts/presentation/viewmodels/partners_viewmodel.dart';

/// Container de injeção de dependência para MVVM
/// Centraliza o registro de todas as dependências do projeto
final GetIt getIt = GetIt.instance;

/// Configura todas as dependências do projeto
Future<void> configureDependencies() async {
  // Data Sources
  getIt.registerLazySingleton<DiscountsApiDataSource>(
    () => DiscountsApiDataSourceImpl(),
  );

  getIt.registerLazySingleton<PartnerApiDataSource>(
    () => PartnerApiDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<DiscountTableRepository>(
    () => DiscountTableRepositoryImpl(getIt<DiscountsApiDataSource>()),
  );

  getIt.registerLazySingleton<PartnerRepository>(
    () => PartnerRepositoryImpl(getIt<PartnerApiDataSource>()),
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

  getIt.registerLazySingleton<GetAllPartnersUseCase>(
    () => GetAllPartnersUseCase(getIt<PartnerRepository>()),
  );
  getIt.registerLazySingleton<UpdatePartnerClientsAmountUseCase>(
    () => UpdatePartnerClientsAmountUseCase(getIt<PartnerRepository>()),
  );
  getIt.registerLazySingleton<UpdatePartnerDailyPriceUseCase>(
    () => UpdatePartnerDailyPriceUseCase(getIt<PartnerRepository>()),
  );
  getIt.registerLazySingleton<UpdatePartnerDiscountsTableUseCase>(
    () => UpdatePartnerDiscountsTableUseCase(
      getIt<PartnerRepository>(),
      getIt<DiscountTableRepository>(), // Reutiliza o repositório já registrado
    ),
  );
  getIt.registerLazySingleton<DeletePartnerUseCase>(
    () => DeletePartnerUseCase(getIt<PartnerRepository>()),
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

  getIt.registerFactory<PartnersViewModel>(
    () => PartnersViewModel(
      getIt<GetAllPartnersUseCase>(),
      getIt<
        GetAllDiscountTablesUseCase
      >(), // Reutiliza o use case já registrado
      getIt<UpdatePartnerClientsAmountUseCase>(),
      getIt<UpdatePartnerDailyPriceUseCase>(),
      getIt<UpdatePartnerDiscountsTableUseCase>(),
      getIt<DeletePartnerUseCase>(),
    ),
  );
}

/// Resolve uma dependência do tipo especificado
T get<T extends Object>() => getIt.get<T>();

/// Resolve uma dependência do tipo especificado com parâmetros nomeados
T getWithParam<T extends Object, P extends Object>(P param) =>
    getIt.get<T>(param1: param);
