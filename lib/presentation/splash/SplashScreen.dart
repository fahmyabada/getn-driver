import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/strings.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/auth/DriverInformationScreen.dart';
import 'package:getn_driver/presentation/auth/SignInScreen.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/notificationService/local_notification_service.dart';
import 'package:getn_driver/presentation/request/RequestScreen.dart';
import 'package:getn_driver/presentation/request/request_cubit.dart';
import 'package:getn_driver/presentation/requestDetails/RequestDetailsScreen.dart';
import 'package:getn_driver/presentation/splash/splash_screen_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FirebaseMessaging _messaging;
  String idRequest = "";

  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize(context);
    registerNotification();
  }


  void registerNotification() async {
    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    print('token=****************** $idToken');
    _messaging.getToken().then((token) {
      print('token fcm=****************** $token');
    });
    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
      // 1. This method call when app in terminated state and you get a notification
      // when you click on notification app open from terminated state and you can get notification data in this method
      _messaging.getInitialMessage().then((RemoteMessage? message) {
        if (message?.data['typeId'] != null) {
          if (kDebugMode) {
            print("getInitialMessage.listen********${message?.data}");
          }
          setState(() {
            idRequest = message?.data['typeId'];
          });
        }
      });

      // 2. This method only call when App in forground it mean app must be opened
      FirebaseMessaging.onMessage.listen(
        (message) {
          if (kDebugMode) {
            print("onMessage.title***** ${message.notification!.title}");
            print("onMessage.body***** ${message.notification!.body}");
            print("onMessage.listen********${message.data}");
          }

          if (message.notification != null) {
            LocalNotificationService.createAndDisplayNotification(message);
          }
          if (message.data['type'] != null) {
            if (getIt<SharedPreferences>().getString('typeScreen') != null &&
                getIt<SharedPreferences>().getString('typeScreen') ==
                    message.data['type']) {
              switch (message.data['page']) {
                case "RequestCurrent":
                  RequestCubit.get(navigatorKey.currentContext)
                      .getRequestCurrent(1);
                  RequestCubit.get(navigatorKey.currentContext).typeRequest =
                      "current";
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(0);
                  break;
                case "RequestUpComing":
                  RequestCubit.get(navigatorKey.currentContext).indexUpComing =
                      1;
                  RequestCubit.get(navigatorKey.currentContext)
                      .getRequestUpComing(1);
                  RequestCubit.get(navigatorKey.currentContext).typeRequest =
                      "upComing";
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(1);
                  break;
                case "RequestPast":
                  RequestCubit.get(navigatorKey.currentContext).indexPast = 1;
                  RequestCubit.get(navigatorKey.currentContext)
                      .getRequestPast(1);
                  RequestCubit.get(navigatorKey.currentContext).typeRequest =
                      "past";
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(2);
                  break;
                case "RequestPending":
                  RequestCubit.get(navigatorKey.currentContext).indexPending =
                      1;
                  RequestCubit.get(navigatorKey.currentContext)
                      .getRequestPending(1);
                  RequestCubit.get(navigatorKey.currentContext).typeRequest =
                      "pending";
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(3);
                  break;
              }
            }
          }
        },
      );

      // 3. This method only call when App in background and not terminated(not closed)
      // when you click on notification app open from background state and you can get notification data in this method
      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) {
          if (kDebugMode) {
            print(
                "onMessageOpenedApp.title***** ${message.notification!.title}");
            print("onMessageOpenedApp.body***** ${message.notification!.body}");
            print("onMessageOpenedApp.data********${message.data}");
          }
          if (message.data['typeId'] != null) {
            LocalNotificationService.goToNextScreen(message.data['typeId'], false);
          }
        },
      );
    }
  }


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
            if (getIt<SharedPreferences>().getString("typeSign") != null &&
                getIt<SharedPreferences>().getString("token") != null) {
              if (getIt<SharedPreferences>().getString("typeSign") == "sign") {
                navigateAndFinish(context, const DriverInformationScreen());
              } else if (getIt<SharedPreferences>().getString("typeSign") ==
                  "signWithInformation") {
                if (idRequest.isNotEmpty) {
                  LocalNotificationService.goToNextScreen(idRequest, true);
                } else {
                  navigateAndFinish(context, const RequestScreen());
                }
              } else {
                navigateAndFinish(context, const SignInScreen());
              }
            } else {
              navigateAndFinish(context, const SignInScreen());
            }
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
                    style: TextStyle(fontSize: 30.sp, color: Colors.white),
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
