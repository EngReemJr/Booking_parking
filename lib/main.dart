//import 'package:firstapp/theme_service.dart';
import 'dart:async';
import 'dart:io';


import 'package:chat_part/reposetories/firestoreHelper.dart';
import 'package:chat_part/screens/HomePage.dart';
import 'package:chat_part/screens/loginScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:chat_part/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'app_router/app_router.dart';
import 'auth/providers/auth_ptoviders.dart';
import 'firebase_options.dart';

/*import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'Activity.dart';
import 'Park.dart';
import 'Settings.dart';
import 'PaymentPage.dart';
import 'main_provider.dart';
import 'Reserve.dart';
import 'Settings.dart';
import 'abc.dart';
import 'introductionScreen.dart';*/

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
Future<void> main() async {
  // await GetStorage.init();


  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
 // 'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

   // return MultiProvider(
    /*    providers: [
        ChangeNotifierProvider<AuthProvider>(
        create: (context) {
      return AuthProvider();
    },
    ),
   /* ChangeNotifierProvider<MainProvider>(
    create: (context) {
    return MainProvider();
    },
    ),*/
    ],*/
    return ChangeNotifierProvider<AuthProvider>(
    create: (context) {
      //return AuthProvider.authProvider;
      return AuthProvider();
    },

    child: AppInit());
  }

  }

class AppInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: AppRouter.appRouter.navigatorKey,
     /* theme: ThemeService().lightTheme,
      darkTheme: ThemeService().darkTheme,
      themeMode: ThemeService().getThemeMode(),*/
      title: "flutter Login UI",
      debugShowCheckedModeBanner: false,
      home: SplachScreen()
      //HomePage()
      /*Activity(),
      routes: {
        '/second': (context) => DemoApp(),
        '/Settings': (context) => Settings(),
        '/Activity': (context) => Activity(),
        '/Park': (context) => Park(),
        '/MyOrderScreen': (context) => MyOrderScreen(),*/

    //  },
    );
  }
}

