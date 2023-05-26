

import 'dart:async';
import 'package:chat_part/app_router/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class HelperNotification {

  HelperNotification._();
 static HelperNotification helperNotification = HelperNotification._();
  late AndroidNotificationChannel channel;

  static void notificationTapBackground(NotificationResponse notificationResponse) {
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

   Future<void> initialize (FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {

    final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
    var androidInitialize= new AndroidInitializationSettings ('notification_icon');
  var IOSInitialize = new DarwinInitializationSettings();
  var initializationsSettings = new InitializationSettings (
      android: androidInitialize,
      iOS: IOSInitialize);
    const String navigationActionId = 'id_3';

    await flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
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
       // return;
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,

    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
    FirebaseMessaging.onMessage.listen(showFlutterNotification) ;


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published! ${message.notification!.body!}' );
      AppRouter.appRouter.showCustomDialoug('New Notification' , message.notification!.body!);
    });
   }
  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ),
      );
    }
  }
}


