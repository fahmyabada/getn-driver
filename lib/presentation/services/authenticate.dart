import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/presentation/auth/DriverInformationScreen.dart';
import 'package:getn_driver/presentation/auth/SignInScreen.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/request/RequestScreen.dart';
import 'package:getn_driver/presentation/request/request_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  /// returns the initial screen depending on the authentication results
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        print("signIn**************** ${snapshot.data!.refreshToken}");
        if (snapshot.hasData) {
          if (getIt<SharedPreferences>().getString("typeSign") != null &&
              getIt<SharedPreferences>().getString("token") != null) {
            if (getIt<SharedPreferences>().getString("typeSign") == "sign") {
              return const DriverInformationScreen();
            } else if (getIt<SharedPreferences>().getString("typeSign") ==
                "signWithInformation") {
              return BlocProvider(
                  create: (context) => RequestCubit(),
                  child: const RequestScreen());
            } else {
              return const SignInScreen();
            }
          } else {
            return const SignInScreen();
          }
        } else {
          return const SignInScreen();
        }
      },
    );
  }

  /// This method is used to logout the `FirebaseUser`
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  /// This method is used to login the user
  ///  `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
  /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
  // signIn(BuildContext context, AuthCredential authCreds) async {
  //   final result = await FirebaseAuth.instance.signInWithCredential(authCreds);
  //   print("signIn**************** ${result.credential!.accessToken}");
  //   if (result.user != null) {
  //     if (getIt<SharedPreferences>().getString("typeSign") == "sign") {
  //       return const DriverInformationScreen();
  //     } else if (getIt<SharedPreferences>().getString("typeSign") ==
  //         "signWithInformation") {
  //       return BlocProvider(
  //           create: (context) => RequestCubit(),
  //           child: const RequestScreen());
  //     } else {
  //       return const SignInScreen();
  //     }
  //   } else {
  //     print("Error");
  //   }
  // }
  Future<void> signIn(BuildContext context, AuthCredential authCreds) async {
    final result =
    await FirebaseAuth.instance.signInWithCredential(authCreds);

    if (result.user != null) {
      print('signIn***********${result.credential!.accessToken}');
    } else {
      print("Error");
    }
  }

  /// get the `smsCode` from the user
  /// when used different phoneNumber other than the current (running) device
  /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
  signInWithOTP(BuildContext context, smsCode, verId) {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(context, authCreds);
  }
}
