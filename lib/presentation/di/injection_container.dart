import 'package:get_it/get_it.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/repository/infoBranch/InfoBranchRemoteDataSource.dart';
import 'package:getn_driver/data/repository/infoBranch/InfoBranchRepositoryImpl.dart';
import 'package:getn_driver/data/repository/infoPlace/InfoPlaceRemoteDataSource.dart';
import 'package:getn_driver/data/repository/infoPlace/InfoPlaceRepositoryImpl.dart';
import 'package:getn_driver/data/repository/tripCreate/TripCreateRemoteDataSource.dart';
import 'package:getn_driver/data/repository/tripCreate/TripCreateRepositoryImpl.dart';
import 'package:getn_driver/data/repository/auth/AuthRemoteDataSource.dart';
import 'package:getn_driver/data/repository/auth/AuthRepositoryImpl.dart';
import 'package:getn_driver/data/repository/branchesPlaces/BranchesPlacesRemoteDataSource.dart';
import 'package:getn_driver/data/repository/branchesPlaces/BranchesPlacesRepositoryImpl.dart';
import 'package:getn_driver/data/repository/recomendPlaces/RecomendPlacesRemoteDataSource.dart';
import 'package:getn_driver/data/repository/recomendPlaces/RecomendPlacesRepositoryImpl.dart';
import 'package:getn_driver/data/repository/request/RequestRemoteDataSource.dart';
import 'package:getn_driver/data/repository/request/RequestRepositoryImpl.dart';
import 'package:getn_driver/data/repository/requestDetails/RequestDetailsRemoteDataSource.dart';
import 'package:getn_driver/data/repository/requestDetails/RequestDetailsRepositoryImpl.dart';
import 'package:getn_driver/data/repository/tripDetails/TripDetailsRemoteDataSource.dart';
import 'package:getn_driver/data/repository/tripDetails/TripDetailsRepositoryImpl.dart';
import 'package:getn_driver/domain/repository/InfoBranchRepository.dart';
import 'package:getn_driver/domain/repository/InfoPlaceRepository.dart';
import 'package:getn_driver/domain/repository/TripCreateRepository.dart';
import 'package:getn_driver/domain/repository/BranchesPlaceRepository.dart';
import 'package:getn_driver/domain/repository/RecomendPlaceRepository.dart';
import 'package:getn_driver/domain/repository/RequestDetailsRepository.dart';
import 'package:getn_driver/domain/repository/RequestRepository.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';
import 'package:getn_driver/domain/repository/TripDetailsRepository.dart';
import 'package:getn_driver/domain/usecase/infoBranch/GetBranchesInfoBranchUseCase.dart';
import 'package:getn_driver/domain/usecase/infoBranch/InfoPlaceBranchUseCase.dart';
import 'package:getn_driver/domain/usecase/infoPlace/InfoPlaceUseCase.dart';
import 'package:getn_driver/domain/usecase/tripCreate/CreateTripUseCase.dart';
import 'package:getn_driver/domain/usecase/branchesPlaces/GetBranchesPlacesUseCase.dart';
import 'package:getn_driver/domain/usecase/recomendPlaces/GetRecomendPlacesUseCase.dart';
import 'package:getn_driver/domain/usecase/request/GetRequestUseCase.dart';
import 'package:getn_driver/domain/usecase/request/PutRequestUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetCurrentLocationUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetRequestDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetTripsRequestDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/PutRequestDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/EditInformationUserUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetCountriesUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetRoleUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/LoginUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/RegisterUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/SendOtpUseCase.dart';
import 'package:getn_driver/domain/usecase/tripCreate/GetPlaceDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/tripCreate/GetSearchLocationUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/GetTripDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/PutTripDetailsUseCase.dart';
import 'package:getn_driver/presentation/ui/auth/cubit/cubit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';


final getIt = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  getIt.registerFactory(() => SignCubit());


  // Use cases
  getIt.registerLazySingleton(() => GetCountriesUseCase(getIt()));
  getIt.registerLazySingleton(() => SendOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => GetRoleUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => EditInformationUserUseCase(getIt()));
  getIt.registerLazySingleton(() => GetRequestUseCase(getIt()));
  getIt.registerLazySingleton(() => GetRequestDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTripsRequestDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => PutRequestUseCase(getIt()));
  getIt.registerLazySingleton(() => PutRequestDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => PutTripDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTripDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetSearchLocationUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPlaceDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentLocationUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateTripUseCase(getIt()));
  getIt.registerLazySingleton(() => GetRecomendPlacesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetBranchesPlacesUseCase(getIt()));
  getIt.registerLazySingleton(() => InfoPlaceUseCase(getIt()));
  getIt.registerLazySingleton(() => GetBranchesInfoBranchUseCase(getIt()));
  getIt.registerLazySingleton(() => InfoPlaceBranchUseCase(getIt()));

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<RequestRepository>(
        () => RequestRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<RequestDetailsRepository>(
        () => RequestDetailsRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<TripDetailsRepository>(
        () => TripDetailsRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<TripCreateRepository>(
        () => TripCreateRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<RecomendPlaceRepository>(
        () => RecomendPlacesRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<BranchesPlaceRepository>(
        () => BranchesPlacesRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<InfoPlaceRepository>(
        () => InfoPlaceRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<InfoBranchRepository>(
        () => InfoBranchRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());

  getIt.registerLazySingleton<RequestRemoteDataSource>(
          () => RequestRemoteDataSourceImpl());

  getIt.registerLazySingleton<RequestDetailsRemoteDataSource>(
          () => RequestDetailsRemoteDataSourceImpl());

  getIt.registerLazySingleton<TripDetailsRemoteDataSource>(
          () => TripDetailsRemoteDataSourceImpl());

  getIt.registerLazySingleton<TripCreateRemoteDataSource>(
          () => TripCreateRemoteDataSourceImpl());

  getIt.registerLazySingleton<RecomendPlacesRemoteDataSource>(
          () => RecomendPlacesRemoteDataSourceImpl());

  getIt.registerLazySingleton<BranchesPlacesRemoteDataSource>(
          () => BranchesPlacesRemoteDataSourceImpl());

  getIt.registerLazySingleton<InfoPlaceRemoteDataSource>(
          () => InfoPlaceRemoteDataSourceImpl());

  getIt.registerLazySingleton<InfoBranchRemoteDataSource>(
          () => InfoBranchRemoteDataSourceImpl());

  //! Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
