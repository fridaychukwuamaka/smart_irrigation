import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_irrigation/screens/home_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  '1',
  'name',
  'description',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: Color(0xFF55DEBF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: MaterialColor(
          0xFF55DEBF,
          <int, Color>{
            50: Color(0xFF55DEBF),
            100: Color(0xFF55DEBF),
            200: Color(0xFF55DEBF),
            300: Color(0xFF55DEBF),
            400: Color(0xFF55DEBF),
            500: Color(0xFF55DEBF),
            600: Color(0xFF55DEBF),
            700: Color(0xFF55DEBF),
            800: Color(0xFF55DEBF),
            900: Color(0xFF55DEBF),
          },
        ),
        scaffoldBackgroundColor: Color(0xFFF1F9F9),
        platform: TargetPlatform.iOS,
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          textStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: Colors.black,
          indicator: BoxDecoration(color: Colors.transparent),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
          bodyText2: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          subtitle2: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.normal,
          ),
          headline5: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
          headline6: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          button: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
