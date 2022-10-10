import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/firebase_options.dart';
import 'package:getn_driver/presentation/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/request/request_cubit.dart';
import 'package:getn_driver/presentation/requestDetails/request_details_cubit.dart';
import 'package:getn_driver/presentation/splash/SplashScreen.dart';
import 'package:getn_driver/presentation/tripDetails/trip_details_cubit.dart';

void main() async {
// for error connection with api
  HttpOverrides.global = MyHttpOverrides();

  // for example ensure Initialized shared perefence
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  //for dependency injection
  await init();

  await DioHelper.init();

  runApp(const MyApp());
}

Future<void> backgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('messageData ********=${message.data.toString()}');
    print("hhhhhhhhhh");
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
      builder: (BuildContext context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SignCubit(),
          ),
          BlocProvider(
            create: (context) => RequestCubit(),
          ),
          BlocProvider(
            create: (context) => RequestDetailsCubit(),
          ),
          BlocProvider(
            create: (context) => TripDetailsCubit(),
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
