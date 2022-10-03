import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  static final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
  StreamController<ReceivedNotification>.broadcast();

  static final StreamController<String?> selectNotificationStream =
  StreamController<String?>.broadcast();


  static void initialize(BuildContext context) {
    //Initialization Settings for iOS
    DarwinInitializationSettings initializationSettingsDarwin =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    /// A notification action which triggers a App navigation event
    const String navigationActionId = 'id_3';

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
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,

      onSelectNotification: (String? payload) async {
        if (kDebugMode) {
          print("onSelectNotification*******");
        }
        if (payload!.isNotEmpty) {
          if (kDebugMode) {
            print("Custom data key ********* = $payload");
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Home(
                title: payload,
              ),
            ),
          );
        }
      },
    );
  }

  static Future<String> _downloadAndSaveFile(
      String? url, String fileName) async {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName.png';
    final http.Response response = await http.get(Uri.parse(url!));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static void createAndDisplayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      String largeIconPath = await _downloadAndSaveFile(
        message.notification?.android?.imageUrl,
        'largeIcon',
      );
      final String bigPicturePath = await _downloadAndSaveFile(
        message.notification?.android?.imageUrl,
        'bigPicture',
      );

      NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "FahmyAbadaNotificationApp",
            "FahmyAbadaNotificationAppChannel",
            playSound: true,
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            icon: message.notification?.android?.smallIcon,
            styleInformation: BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicturePath),
              hideExpandedLargeIcon: true,
            ),
          ),
          iOS:  IOSNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ));

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        //payload : holds the data that is passed through the notification when the notification is tapped
        payload: message.data['title'],
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
