import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/splash/SplashScreen.dart';

void main() async{
// for error connection with api
  HttpOverrides.global = MyHttpOverrides();

  // for example ensure Initialized shared perefence
  WidgetsFlutterBinding.ensureInitialized();

  //for dependency injection
  await init();

  await DioHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 891),
      minTextAdapt: true,
      builder: (BuildContext context, child) =>
      MaterialApp(
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
        home:  const SplashScreen(),
      ),
    );
  }
}


