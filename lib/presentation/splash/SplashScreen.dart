import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/strings.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/auth/signIn/SignInScreen.dart';
import 'package:getn_driver/presentation/onBoarding/OnBoardScreenView.dart';
import 'package:getn_driver/presentation/splash/splash_screen_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SplashScreenCubit()..loadData(),
        child: BlocConsumer<SplashScreenCubit, SplashScreenState>(
            listener: (context, state) {
          if (state is StartState) {
            if (kDebugMode) {
              print('*******StartState');
            }
            navigateTo(context, SignInScreen());
          }
        }, builder: (context, state) {
          return Scaffold(
            backgroundColor: primaryColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40.r, right: 40.r),
                  child: Text(
                    Strings.perfectTaxiBooking,
                    style: TextStyle(
                        fontSize: 30.sp, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 85.r),
                  height: 15.h,
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      accentColor,
                    ),
                    //value: 0.8,
                  ),
                )
              ],
            ),
          );
        }));
  }
}
