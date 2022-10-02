import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/firebase_options.dart';
import 'package:getn_driver/presentation/auth/cubit/cubit.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/splash/SplashScreen.dart';

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
    print('messageTitle ********=${message.notification!.title}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 891),
      minTextAdapt: true,
      builder: (BuildContext context, child) => BlocProvider(
        create: (context) => SignCubit(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GetNDriver',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: white,
            appBarTheme: const AppBarTheme(
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
