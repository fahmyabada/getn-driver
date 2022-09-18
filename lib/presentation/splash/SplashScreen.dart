import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/onBoarding/on_board_screen_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/images/logo2.png'),
      backgroundColor: white,
      showLoader: true,
      loadingText: const Text("Loading..."),
      navigator: OnBoardScreenView(),
      durationInSeconds: 3,
    );
  }
}
