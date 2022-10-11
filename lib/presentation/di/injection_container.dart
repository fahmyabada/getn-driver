import 'package:get_it/get_it.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/repository/auth/AuthRemoteDataSource.dart';
import 'package:getn_driver/data/repository/auth/AuthRepositoryImpl.dart';
import 'package:getn_driver/data/repository/request/RequestRemoteDataSource.dart';
import 'package:getn_driver/data/repository/request/RequestRepositoryImpl.dart';
import 'package:getn_driver/data/repository/requestDetails/RequestDetailsRemoteDataSource.dart';
import 'package:getn_driver/data/repository/requestDetails/RequestDetailsRepositoryImpl.dart';
import 'package:getn_driver/data/repository/tripDetails/TripDetailsRemoteDataSource.dart';
import 'package:getn_driver/data/repository/tripDetails/TripDetailsRepositoryImpl.dart';
import 'package:getn_driver/domain/repository/RequestDetailsRepository.dart';
import 'package:getn_driver/domain/repository/RequestRepository.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';
import 'package:getn_driver/domain/repository/TripDetailsRepository.dart';
import 'package:getn_driver/domain/usecase/request/GetRequestUseCase.dart';
import 'package:getn_driver/domain/usecase/request/PutRequestUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetRequestDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetTripsRequestDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/PutRequestDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/EditInformationUserUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetCountriesUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetRoleUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/LoginUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/RegisterUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/SendOtpUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/GetPlaceDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/GetSearchLocationUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/GetTripDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/PutTripDetailsUseCase.dart';
import 'package:getn_driver/presentation/auth/cubit/cubit.dart';
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

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());

  getIt.registerLazySingleton<RequestRemoteDataSource>(
          () => RequestRemoteDataSourceImpl());

  getIt.registerLazySingleton<RequestDetailsRemoteDataSource>(
          () => RequestDetailsRemoteDataSourceImpl());

  getIt.registerLazySingleton<TripDetailsRemoteDataSource>(
          () => TripDetailsRemoteDataSourceImpl());

  //! Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
