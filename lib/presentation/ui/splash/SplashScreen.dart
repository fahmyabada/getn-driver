import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/notificationService/local_notification_service.dart';
import 'package:getn_driver/presentation/ui/auth/CarRegistrationScreen.dart';
import 'package:getn_driver/presentation/ui/auth/DriverInformationScreen.dart';
import 'package:getn_driver/presentation/ui/language/LanguageScreen.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/notificationSetting/NotificationSettingScreen.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/RequestTabsScreen.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/request_cubit.dart';
import 'package:getn_driver/presentation/ui/splash/splash_screen_cubit.dart';
import 'package:getn_driver/presentation/ui/wallet/wallet_cubit.dart';
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

    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }
    LocalNotificationService.initialize(context);
    registerNotification();
  }

  void registerNotification() async {
    getIt<SharedPreferences>().setString('typeScreen', "splashScreen");

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    // print('token=****************** $idToken');
    // _messaging.getToken().then((token) {
    //   print('token fcm=****************** $token');
    //   getIt<SharedPreferences>().setString('fcmToken', token!);
    // });
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
            } else if (message?.data['type'] == "requestTransaction" ||
                message?.data['type'] == "walletTransaction") {
              print('walletTransactiongetInitialMessage*****************');
              idRequest = 'wallet';
            }
          });

          // LocalNotificationService.createAndDisplayNotification(message!,'');
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
                if (message.data['current_status'] == "cancel") {
                  LocalNotificationService.goToNextScreen(
                      message.data['parentId'], "pop", "tripDetails");
                } else {
                  LocalNotificationService.goToNextScreen(
                      message.data['typeId'], "pushReplacement", "tripDetails");
                }
                LocalNotificationService.createAndDisplayNotification(
                    message, "inSameTrip");
                print("in tripDetails and tripDetailsId equal typeId");
              } else if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('tripDetailsId') !=
                      message.data['typeId']) {
                LocalNotificationService.createAndDisplayNotification(
                    message, "newTrip");
                print("in tripDetails and tripDetailsId not equal typeId");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') !=
                      'requestDetails') {
                LocalNotificationService.createAndDisplayNotification(
                    message, "outTrip");
                print("not tripDetails and not requestDetails");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') ==
                      'requestDetails') {
                print("not tripDetails and in requestDetails");
                // for refresh page
                LocalNotificationService.goToNextScreen(
                    message.data['parentId'],
                    "pushReplacement",
                    "requestDetails");
                // for in click
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
                if (message.data['title_en'] == "Cancel Request") {
                  LocalNotificationService.goToNextScreen(
                      message.data['typeId'], "pushReplacement", "past");
                } else {
                  LocalNotificationService.goToNextScreen(
                      message.data['typeId'],
                      "pushReplacement",
                      "requestDetails");
                }
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
            } else if (message.data['type'] == "requestTransaction" ||
                message.data['type'] == "walletTransaction") {
              if (getIt<SharedPreferences>().getString('typeScreen') ==
                  'WalletScreen') {
                print(
                    '${message.data['type']}***************************equal');
                WalletCubit.get(navigatorKey.currentContext).typeScreen =
                    "wallet";
                WalletCubit.get(navigatorKey.currentContext).indexWallet = 1;
                WalletCubit.get(navigatorKey.currentContext).currentIndex = 0;
                WalletCubit.get(navigatorKey.currentContext).getWallet(1);
                LocalNotificationService.createAndDisplayNotification(
                    message, "inWallet");
              } else {
                print(
                    '${message.data['type']}***************************NotEqual');
                LocalNotificationService.createAndDisplayNotification(
                    message, "outWallet");
              }
            }

            print(
                'ssssssss11***************************${getIt<SharedPreferences>().getString('typeScreen')}');
            print(
                'ssssssss22***************************${getIt<SharedPreferences>().getString('requestDetailsId')}');
            // this comment for update tabs anyway because i may return request tabs after
            // i in request details that open from notification

            // if (message.data['type'] == 'request' &&
            //     (getIt<SharedPreferences>().getString('typeScreen') ==
            //             'request' ||
            //         getIt<SharedPreferences>().getString('typeScreen') == "")) {

            // for update request tabs
            switch (message.data['page']) {
              case "RequestCurrent":
                if (RequestCubit.get(navigatorKey.currentContext).typeRequest ==
                    "current") {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = false;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .index = 0;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .notifyListeners();
                } else {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = true;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(0);
                }
                break;
              case "RequestUpComing":
                if (RequestCubit.get(navigatorKey.currentContext).typeRequest ==
                    "upComing") {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = false;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .index = 1;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .notifyListeners();
                } else {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = true;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(1);
                }
                break;
              case "RequestPast":
                if (RequestCubit.get(navigatorKey.currentContext).typeRequest ==
                    "past") {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = false;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .index = 2;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .notifyListeners();
                } else {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = true;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(2);
                }
                break;
              case "RequestPending":
                // to listen change you should animate to another tab first time and return again
                if (RequestCubit.get(navigatorKey.currentContext).typeRequest ==
                    "pending") {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = false;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .index = 3;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .notifyListeners();
                } else {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = true;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(3);
                }
                break;
            }
            // }
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
                // here if i get same trip id i will refresh page and show notification
                // without enable clickable
                if (message.data['current_status'] == "cancel") {
                  LocalNotificationService.goToNextScreen(
                      message.data['parentId'], "pop", "tripDetails");
                } else {
                  LocalNotificationService.goToNextScreen(
                      message.data['typeId'], "pushReplacement", "tripDetails");
                }
                // LocalNotificationService.createAndDisplayNotification(
                //     message, "inSameTrip");
              } else if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('tripDetailsId') !=
                      message.data['typeId']) {
                LocalNotificationService.goToNextScreen(
                    message.data['parentId'], "pop", "newTrip");
                // LocalNotificationService.createAndDisplayNotification(
                //     message, "newTrip");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') !=
                      'requestDetails') {
                LocalNotificationService.goToNextScreen(
                    message.data['parentId'], "push", "outTrip");
                // LocalNotificationService.createAndDisplayNotification(
                //     message, "outTrip");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'tripDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') ==
                      'requestDetails') {
                // for refresh page
                LocalNotificationService.goToNextScreen(
                    message.data['parentId'],
                    "pushReplacement",
                    "requestDetails");
                // for in click
                // LocalNotificationService.createAndDisplayNotification(
                //     message, "outTripInRequest");
              }
            } else if (message.data['type'] == "request" ||
                message.data['type'] == "payment") {
              if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('requestDetailsId') ==
                      message.data['typeId']) {
                // here if i get same request id i will refresh page and show notification
                // without enable clickable
                if (message.data['title_en'] == "Cancel Request") {
                  LocalNotificationService.goToNextScreen(
                      message.data['typeId'], "pushReplacement", "past");
                } else {
                  LocalNotificationService.goToNextScreen(
                      message.data['typeId'],
                      "pushReplacement",
                      "requestDetails");
                }
                // LocalNotificationService.createAndDisplayNotification(
                //     message, "inSameRequest");
              } else if (getIt<SharedPreferences>().getString('typeScreen') ==
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('requestDetailsId') !=
                      message.data['typeId']) {
                LocalNotificationService.goToNextScreen(message.data['typeId'],
                    "pushReplacement", "requestDetails");
                // LocalNotificationService.createAndDisplayNotification(
                //     message, "newRequest");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') !=
                      'tripDetails') {
                LocalNotificationService.goToNextScreen(
                    message.data['typeId'], "push", "outRequest");
                // LocalNotificationService.createAndDisplayNotification(
                //     message, "outRequest");
              } else if (getIt<SharedPreferences>().getString('typeScreen') !=
                      'requestDetails' &&
                  getIt<SharedPreferences>().getString('typeScreen') ==
                      'tripDetails') {
                LocalNotificationService.goToNextScreen(
                    message.data['typeId'], "pop", "outRequestInTrip");
                // LocalNotificationService.createAndDisplayNotification(
                //     message, "outRequestInTrip");
              }
            } else if (message.data['type'] == "requestTransaction" ||
                message.data['type'] == "walletTransaction") {
              if (getIt<SharedPreferences>().getString('typeScreen') ==
                  'WalletScreen') {
                print(
                    '${message.data['type']}***************************NotEqual1');
                WalletCubit.get(navigatorKey.currentContext).typeScreen =
                    "wallet";
                WalletCubit.get(navigatorKey.currentContext).indexWallet = 1;
                WalletCubit.get(navigatorKey.currentContext).currentIndex = 0;
                WalletCubit.get(navigatorKey.currentContext).getWallet(1);
              } else {
                print(
                    '${message.data['type']}***************************NotEqual2');
                LocalNotificationService.goToNextScreen(
                    "outWallet", "push", "outWallet");
              }
            }

            switch (message.data['page']) {
              case "RequestCurrent":
                if (RequestCubit.get(navigatorKey.currentContext).typeRequest ==
                    "current") {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = false;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .index = 0;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .notifyListeners();
                } else {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = true;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(0);
                }
                break;
              case "RequestUpComing":
                if (RequestCubit.get(navigatorKey.currentContext).typeRequest ==
                    "upComing") {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = false;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .index = 1;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .notifyListeners();
                } else {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = true;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(1);
                }
                break;
              case "RequestPast":
                if (RequestCubit.get(navigatorKey.currentContext).typeRequest ==
                    "past") {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = false;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .index = 2;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .notifyListeners();
                } else {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = true;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(2);
                }
                break;
              case "RequestPending":
                // to listen change you should animate to another tab first time and return again
                if (RequestCubit.get(navigatorKey.currentContext).typeRequest ==
                    "pending") {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = false;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .index = 3;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .notifyListeners();
                } else {
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabControllerChanged = true;
                  RequestCubit.get(navigatorKey.currentContext)
                      .tabController!
                      .animateTo(3);
                }
                break;
            }
          }
        },
      );
    }
    else {
      if (kDebugMode) {
        print('User Not granted permission');
      }
      idRequest = 'NotificationSettingScreen';
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
            if (idRequest == 'NotificationSettingScreen') {
              navigateAndFinish(navigatorKey.currentContext,
                  const NotificationSettingScreen());
            } else {
              if (getIt<SharedPreferences>().getString("typeSign") != null &&
                  getIt<SharedPreferences>().getString("token") != null) {
                if (getIt<SharedPreferences>().getString("typeSign") ==
                    "sign") {
                  navigateAndFinish(context, const DriverInformationScreen());
                } else if (getIt<SharedPreferences>().getString("typeSign") ==
                    "signWithInformation") {
                  navigateAndFinish(context, const CarRegistrationScreen());
                } else if (getIt<SharedPreferences>().getString("typeSign") ==
                    "signWithCarRegistration") {
                  if (idRequest == 'wallet') {
                    LocalNotificationService.goToNextScreen(
                        idRequest, "pushAndRemoveUntil", "wallet");
                  } else if (idRequest.isNotEmpty) {
                    LocalNotificationService.goToNextScreen(
                        idRequest, "pushAndRemoveUntil", "");
                  } else {
                    print(
                        'token******${getIt<SharedPreferences>().getString('token')}');
                    navigateAndFinish(context, const RequestTabsScreen());
                  }
                } else {
                  navigateAndFinish(context, const LanguageScreen());
                }
              } else {
                navigateAndFinish(context, const LanguageScreen());
              }
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
