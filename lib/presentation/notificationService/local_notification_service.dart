import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/RequestDetailsScreen.dart';
import 'package:getn_driver/presentation/ui/request/requestDetails/request_details_cubit.dart';
import 'package:getn_driver/presentation/ui/request/requestTabs/request_cubit.dart';
import 'package:getn_driver/presentation/ui/trip/tripDetails/trip_details_cubit.dart';
import 'package:getn_driver/presentation/ui/wallet/WalletScreen.dart';
import 'package:getn_driver/presentation/ui/wallet/wallet_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Defines a iOS/MacOS notification category for plain actions.
  static const String darwinNotificationCategoryPlain = 'plainCategory';

  /// Defines a iOS/MacOS notification category for text input actions.
  static const String darwinNotificationCategoryText = 'textCategory';

  /// A notification action which triggers a App navigation event
  static const String navigationActionId = 'id_3';

  //Initialization Settings for Android
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

  static List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  static void initialize(BuildContext context) {
    //Initialization Settings for iOS
    DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        await showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: title != null ? Text(title) : null,
            content: body != null ? Text(body) : null,
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  print(
                      "_configureDidReceiveLocalNotificationSubject*************");
                  // await Navigator.of(context).push(
                  //   MaterialPageRoute<void>(
                  //     builder: (BuildContext context) =>
                  //         SecondPage(payload),
                  //   ),
                  // );
                },
                child: const Text('Ok'),
              )
            ],
          ),
        );
      },
      notificationCategories: darwinNotificationCategories,
    );

    // initializationSettings  for Android
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            print(
                "notificationResponseType************ ${notificationResponse.payload}");
            final split = notificationResponse.payload!.split(',');
            final Map<int, String> values = {
              for (int i = 0; i < split.length; i++) i: split[i]
            };
            String? id = values[0];
            String? typeScreen = values[1];

            if (typeScreen == "inSameTrip") {
              // here if i get same trip id i will refresh page and show notification
              // without enable clickable
            } else if (typeScreen == "newTrip") {
              goToNextScreen(id!, "pop", typeScreen!);
            } else if (typeScreen == "outTrip") {
              goToNextScreen(id!, "push", typeScreen!);
            } else if (typeScreen == "outTripInRequest") {
              // here if i get trip id and i now in request details
              // i will refresh page and show notification without enable clickable
              // goToNextScreen(id!, "pushReplacement", "requestDetails");
            } else if (typeScreen == "inSameRequest") {
              // here if i get same request id i will refresh page and show notification
              // without enable clickable
            } else if (typeScreen == "newRequest") {
              goToNextScreen(id!, "pushReplacement", "requestDetails");
            } else if (typeScreen == "outRequest") {
              goToNextScreen(id!, "push", typeScreen!);
            } else if (typeScreen == "outRequestInTrip") {
              goToNextScreen(id!, "pop", typeScreen!);
            } else if (typeScreen == "inWallet") {
              goToNextScreen(id!, "pushReplacement", typeScreen!);
            } else if (typeScreen == "outWallet") {
              goToNextScreen(id!, "push", typeScreen!);
            }

            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              print(
                  "selectedNotificationAction************ ${notificationResponse.payload}");
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static void goToNextScreen(
      String id, String typeTransfer, String typeScreen) {
    print("goToNextScreen1************ $id");
    print("goToNextScreen2************ $typeTransfer");
    print("goToNextScreen3************ $typeScreen");
    if (typeTransfer == "pushAndRemoveUntil") {
      if (typeScreen == 'wallet') {
        navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (context) => WalletCubit(),
                  child: const WalletScreen()),
            ),
            (route) => false);
      } else {
        navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (context) => RequestCubit(),
                  child: RequestDetailsScreen(
                    idRequest: id,
                  )),
            ),
            (route) => false);
      }
    } else if (typeTransfer == "push") {
      if (typeScreen == 'outWallet') {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => WalletCubit(),
                child: const WalletScreen()),
          ),
        );
      } else {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => RequestCubit(),
                child: RequestDetailsScreen(
                  idRequest: id,
                )),
          ),
        );
      }
    } else if (typeTransfer == "pop") {
      navigatorKey.currentState!.pop(id);
    } else if (typeTransfer == "pushReplacement") {
      if (typeScreen == "requestDetails") {
        // for refresh data only and set typeScreen = "" because usually equal past

        RequestDetailsCubit.get(navigatorKey.currentContext).typeScreen = "";
        getIt<SharedPreferences>().setString('requestDetailsId', id);
        RequestDetailsCubit.get(navigatorKey.currentContext).getRequestDetails(id);

        // for refresh page but have problem when back and you depend on refresh page
        // not refresh page because not have get id
        /*navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => RequestCubit(),
                child: RequestDetailsScreen(
                  idRequest: id,
                )),
          ),
        );*/
      } else if (typeScreen == "tripDetails") {
        // for refresh data only
        TripDetailsCubit.get(navigatorKey.currentContext).getTripDetails(id);

        // for refresh page but have problem when back and you depend on refresh page
        // not refresh page because not have get id
        /*navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => RequestCubit(),
                child: TripDetailsScreen(
                  idTrip: id,
                )),
          ),
        );*/

      } else if (typeScreen == "past") {
        // for refresh data only
        RequestDetailsCubit.get(navigatorKey.currentContext).typeScreen =
            "past";
        RequestDetailsCubit.get(navigatorKey.currentContext)
            .getRequestDetails(id);

        // for refresh page but have problem when back and you depend on refresh page
        // not refresh page because not have get id
        /* navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => RequestCubit(),
                child: RequestDetailsScreen(
                  idRequest: id,
                  typeScreen: "past",
                )),
          ),
        );*/
      } else if (typeScreen == "inWallet") {
        // for refresh data only
        WalletCubit.get(navigatorKey.currentContext).typeScreen = "wallet";
        WalletCubit.get(navigatorKey.currentContext).indexWallet = 1;
        WalletCubit.get(navigatorKey.currentContext).getWallet(1);
      }
    }
  }

  static void createAndDisplayNotification(
      RemoteMessage message, String? type) async {
    try {
      String? payloadValue;

      // const id = 1;
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
        categoryIdentifier: darwinNotificationCategoryPlain,
      );

      NotificationDetails notificationDetails = const NotificationDetails(
          android: AndroidNotificationDetails(
            "GetnDriverChannel",
            "GetnDriverChannel",
            playSound: true,
            visibility: NotificationVisibility.public,
            enableVibration: true,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: iosNotificationDetails);

      if (type == "inSameTrip") {
        payloadValue = message.data['typeId'];
      } else if (type == "newTrip") {
        payloadValue = message.data['parentId'];
      } else if (type == "outTrip") {
        payloadValue = message.data['parentId'];
      } else if (type == "outTripInRequest") {
        payloadValue = message.data['parentId'];
      } else if (type == "inSameRequest" ||
          type == "newRequest" ||
          type == "outRequest" ||
          type == "outRequestInTrip") {
        payloadValue = message.data['typeId'];
      } else if (type == "inWallet") {
        payloadValue = 'inWallet';
      } else if (type == "outWallet") {
        payloadValue = 'outWallet';
      }

      await _notificationsPlugin.show(
        id,
        LanguageCubit.get(navigatorKey.currentContext).isEn
            ? message.data['title_en']
            : message.data['title_ar'],
        LanguageCubit.get(navigatorKey.currentContext).isEn
            ? message.data['content_en']
            : message.data['content_ar'],
        notificationDetails,
        //payload : holds the data that is passed through the notification when the notification is tapped
        payload: '$payloadValue,$type',
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
