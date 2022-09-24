import 'package:get_it/get_it.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/repository/signIn/SignInRemoteDataSource.dart';
import 'package:getn_driver/data/repository/signIn/SignInRepositoryImpl.dart';
import 'package:getn_driver/domain/repository/SignInRepository.dart';
import 'package:getn_driver/domain/usecase/signIn/EditInformationUserUseCase.dart';
import 'package:getn_driver/domain/usecase/signIn/GetCountriesUseCase.dart';
import 'package:getn_driver/domain/usecase/signIn/GetRoleUseCase.dart';
import 'package:getn_driver/domain/usecase/signIn/LoginUseCase.dart';
import 'package:getn_driver/domain/usecase/signIn/RegisterUseCase.dart';
import 'package:getn_driver/domain/usecase/signIn/SendOtpUseCase.dart';
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

  // Repository
  getIt.registerLazySingleton<SignInRepository>(
    () => SignInRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<SignInRemoteDataSource>(
      () => SignInRemoteDataSourceImpl());


  //! Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
