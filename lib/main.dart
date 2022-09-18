import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/presentation/onBoarding/on_board_screen_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
        ),
        home:  OnBoardScreenView(),
      ),
    );
  }
}

