import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/main_cubit.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/notificationService/local_notification_service.dart';
import 'package:getn_driver/presentation/ui/auth/CarRegistrationScreen.dart';
import 'package:getn_driver/presentation/ui/auth/DriverInformationScreen.dart';
import 'package:getn_driver/presentation/ui/onBoarding/OnBoardScreenView.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/RequestTabsScreen.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/request_cubit.dart';
import 'package:getn_driver/presentation/ui/splash/splash_screen_cubit.dart';
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
    getIt<SharedPreferences>().setString('typeScreen', "splashScreen");

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    // print('token=****************** $idToken');
    _messaging.getToken().then((token) {
      print('token fcm=****************** $token');
      getIt<SharedPreferences>().setString('fcmToken', token!);
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
        if (message?.data['type'] != null) {
          if (kDebugMode) {
            print("getInitialMessage.listen********${message?.data}");
          }
          setState(() {
            if (message?.data['type'] == "request" ||
                message?.data['type'] == "payment") {
              idRequest = message?.data['typeId'];
            } else if (message?.data['type'] == "trip") {
              idRequest = message?.data['parentId'];
            }
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

          if (message.notification != null && message.data.isNotEmpty) {
            // for show notification
            if (message.data['type'] == "trip") {
              if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('tripDetailsId') ==
                      message.data['typeId']) {
                // here if i get same trip id i will refresh page and show notification
                // without enable clickable
                LocalNotificationService.goToNextScreen(
                    message.data['typeId'], "pushReplacement", "tripDetails");
                LocalNotificationService.createAndDisplayNotification(
                    message, "inSameTrip");
              } else if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('tripDetailsId') !=
                      message.data['typeId']) {
                LocalNotificationService.createAndDisplayNotification(
                    message, "newTrip");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') !=
                      'requestDetails') {
                LocalNotificationService.createAndDisplayNotification(
                    message, "outTrip");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') ==
                      'requestDetails') {
                LocalNotificationService.createAndDisplayNotification(
                    message, "outTripInRequest");
              }
            } else if (message.data['type'] == "request" ||
                message.data['type'] == "payment") {
              if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('requestDetailsId') ==
                      message.data['typeId']) {
                // here if i get same request id i will refresh page and show notification
                // without enable clickable
                LocalNotificationService.goToNextScreen(message.data['typeId'],
                    "pushReplacement", "requestDetails");
                LocalNotificationService.createAndDisplayNotification(
                    message, "inSameRequest");
              } else if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('requestDetailsId') !=
                      message.data['typeId']) {
                LocalNotificationService.createAndDisplayNotification(
                    message, "newRequest");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') !=
                      'tripDetails') {
                LocalNotificationService.createAndDisplayNotification(
                    message, "outRequest");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') ==
                      'tripDetails') {
                LocalNotificationService.createAndDisplayNotification(
                    message, "outRequestInTrip");
              }
            }

            // for update request tabs
            if (message.data['type'] == 'request' &&
                getIt<SharedPreferences>().getString('typeScreen') ==
                    'request') {
              switch (message.data['page']) {
                case "RequestCurrent":
                  MainCubit.get(navigatorKey.currentContext).tabController!.animateTo(0);
                  break;
                case "RequestUpComing":
                  MainCubit.get(navigatorKey.currentContext).tabController!.animateTo(1);
                  break;
                case "RequestPast":
                  MainCubit.get(navigatorKey.currentContext).tabController!.animateTo(2);
                  break;
                case "RequestPending":
                  MainCubit.get(navigatorKey.currentContext).tabController!.animateTo(3);
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

          if (message.data.isNotEmpty) {
            if (message.data['type'] == "trip") {
              if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('tripDetailsId') ==
                      message.data['typeId']) {
                LocalNotificationService.goToNextScreen(
                    message.data['typeId'], "pushReplacement", "tripDetails");
              } else if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('tripDetailsId') !=
                      message.data['typeId']) {
                LocalNotificationService.goToNextScreen(
                    message.data['parentId'], "pop", "newTrip");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') !=
                      'requestDetails') {
                LocalNotificationService.goToNextScreen(
                    message.data['parentId'], "push", "outTrip");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') ==
                      'requestDetails') {
                LocalNotificationService.goToNextScreen(
                    message.data['parentId'],
                    "pushReplacement",
                    "requestDetails");
              }
            } else if (message.data['type'] == "request" ||
                message.data['type'] == "payment") {
              if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('requestDetailsId') ==
                      message.data['typeId']) {
                LocalNotificationService.goToNextScreen(message.data['typeId'],
                    "pushReplacement", "requestDetails");
              } else if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('requestDetailsId') !=
                      message.data['typeId']) {
                LocalNotificationService.goToNextScreen(message.data['typeId'],
                    "pushReplacement", "requestDetails");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') !=
                      'tripDetails') {
                LocalNotificationService.goToNextScreen(
                    message.data['typeId'], "push", "outRequest");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') ==
                      'tripDetails') {
                LocalNotificationService.goToNextScreen(
                    message.data['typeId'], "pop", "outRequestInTrip");
              }
            }
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
                navigateAndFinish(context, const CarRegistrationScreen());
              } else if (getIt<SharedPreferences>().getString("typeSign") ==
                  "signWithCarRegistration") {
                if (idRequest.isNotEmpty) {
                  LocalNotificationService.goToNextScreen(
                      idRequest, "pushAndRemoveUntil", "");
                } else {
                  navigateAndFinish(
                      context,
                      BlocProvider(
                          create: (context) => RequestCubit(),
                          child: const RequestTabsScreen()));
                }
              } else {
                navigateAndFinish(context, OnBoardScreenView());
              }
            } else {
              navigateAndFinish(context, OnBoardScreenView());
            }
          }
        }, builder: (context, state) {
          return Scaffold(
            backgroundColor: white,
            body: Center(
              child: SizedBox(
                width: 300.w,
                height: 500.h,
                child: const Image(
                  image: AssetImage('assets/logoGif2.gif'),
                ),
              ),
            ),
          );
        }));
  }
}
