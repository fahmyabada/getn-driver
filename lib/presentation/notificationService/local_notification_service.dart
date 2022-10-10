import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/request/request_cubit.dart';
import 'package:getn_driver/presentation/requestDetails/RequestDetailsScreen.dart';
import 'package:getn_driver/presentation/tripDetails/TripDetailsScreen.dart';
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
            if (getIt<SharedPreferences>().getString('typeScreen') ==
                'requestDetails') {
              goToNextScreen(notificationResponse.payload!, "pushReplacement",
                  "requestDetails");
            } else if (getIt<SharedPreferences>().getString('typeScreen') ==
                'tripDetails') {
              if (notificationResponse.payload! == "inTripDetails") {
                goToNextScreen(notificationResponse.payload!, "pushReplacement",
                    "tripDetails");
              } else {
                goToNextScreen(notificationResponse.payload!, "pop", "");
              }
            } else {
              goToNextScreen(notificationResponse.payload!, "push", "");
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

  static void goToNextScreen(String id, String typeFinish, String typeScreen) {
    if (typeFinish == "pushAndRemoveUntil") {
      navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => RequestCubit(),
                child: RequestDetailsScreen(
                  idRequest: id,
                )),
          ),
          (route) => false);
    } else if (typeFinish == "push") {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => RequestCubit(),
              child: RequestDetailsScreen(
                idRequest: id,
              )),
        ),
      );
    } else if (typeFinish == "pop") {
      navigatorKey.currentState!.pop(id);
    } else if (typeFinish == "pushReplacement") {
      if (typeScreen == "requestDetails") {
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => RequestCubit(),
                child: RequestDetailsScreen(
                  idRequest: id,
                )),
          ),
        );
      } else {
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => RequestCubit(),
                child: TripDetailsScreen(
                  id: id,
                )),
          ),
        );
      }
    }
  }

  static void createAndDisplayNotification(
      RemoteMessage message, String? type) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
        categoryIdentifier: darwinNotificationCategoryPlain,
      );

      NotificationDetails notificationDetails = const NotificationDetails(
          android: AndroidNotificationDetails(
            "FahmyAbadaNotificationApp",
            "FahmyAbadaNotificationAppChannel",
            playSound: true,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: iosNotificationDetails);

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        //payload : holds the data that is passed through the notification when the notification is tapped
        payload: type!.isEmpty
            ? getIt<SharedPreferences>().getString('typeScreen') ==
                    'tripDetails'
                ? message.data['parentId']
                : message.data['typeId']
            : message.data['typeId'],
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
