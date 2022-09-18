import 'package:get_it/get_it.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';


final getIt = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  // getIt.registerFactory(() => LoginCubit());


  // Use cases
  // getIt.registerLazySingleton(() => LoginUseCase(getIt()));

  // Repository
  // getIt.registerLazySingleton<LoginRepository>(
  //   () => LoginRepositoryImpl(
  //     getIt(),
  //     getIt(),
  //   ),
  // );

  // Data sources
  // getIt.registerLazySingleton<LoginRemoteDataSource>(
  //     () => LoginRemoteDataSourceImpl());


  //! Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
