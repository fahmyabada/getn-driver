import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/firebase_options.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/request_details_cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/request_cubit.dart';
import 'package:getn_driver/presentation/ui/splash/SplashScreen.dart';
import 'package:getn_driver/presentation/ui/trip/tripDetails/trip_details_cubit.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
// for error connection with api
  HttpOverrides.global = MyHttpOverrides();

  // for example ensure Initialized shared Preferences
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  //for dependency injection
  await init();

  await DioHelper.init();

  // runApp(DevicePreview(
  //   enabled: true,
  //   builder: (context) => MyApp(),
  // ));


  runApp(const MyApp());
}

Future<void> backgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('messageData ********=${message.data.toString()}');
    print('messageTitle ********=${message.notification!.toString()}');
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 891),
      minTextAdapt: true,
      builder: (BuildContext context, child) =>
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => LanguageCubit(),
              ),
              BlocProvider(
                create: (context) => RequestDetailsCubit(),
              ),
              BlocProvider(
                create: (context) => TripDetailsCubit(),
              ),
              BlocProvider(
                create: (context) => RequestCubit(),
              ),
            ],
            child: MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'GetNDriver',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: white,
                appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: accentColor,
                    statusBarBrightness: Brightness.light,
                    statusBarIconBrightness: Brightness.light,
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  color: white,
                  elevation: 0.0,
                ),
              ),
              home: const SplashScreen(),
            ),
          ),
    );
  }
}
