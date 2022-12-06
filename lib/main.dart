import 'dart:async';

import 'package:driver_app/forget_password.dart';
import 'package:driver_app/forget_password_reset.dart';
import 'package:driver_app/forget_password_verify.dart';
import 'package:driver_app/login.dart';
import 'package:driver_app/notification.dart';
import 'package:driver_app/password_change.dart';
import 'package:driver_app/profile.dart';
import 'package:driver_app/profile_edit.dart';
import 'package:driver_app/sub_main.dart';
import 'package:driver_app/sub_main2.dart';
import 'package:driver_app/trip.dart';
import 'package:driver_app/trip_detail.dart';
import 'package:driver_app/trip_detail_pending.dart';
import 'package:driver_app/trip_track.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'home_trips.dart';

Future<void> _firebackgroundMessageHandler(RemoteMessage message) async {
  print("Handling a background message ${message.messageId}");
  print("Handling a background message body ${message.toString()}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebackgroundMessageHandler);

  runApp(EasyLocalization(
      path: 'assets/locales',
      supportedLocales: [Locale('en', 'UK'), Locale('ar', 'JO')],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      title: 'Flutter Demo',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/forget_password': (context) => const ForgetPassword(),
        '/forget_password_verify': (context) => const ForgetPasswordVerify(),
        '/verify_password': (context) => const ForgetPasswordReset(),
        '/main': (context) => const SubMain(),
        '/profile': (context) => const Profile(),
        '/profile_edit': (context) => const EditProfile(),
        '/password_change': (context) => const ChangePassword(),
        '/notification': (context) => const NotificationPage(),
        '/trip': (context) => const HomeTripsPage(),
        '/trip_track': (context) => const TripTrack(),
        '/trip_detail_pending': (context) => const TripDetailPending(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyLogin())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/splash.jpg"), fit: BoxFit.cover)),
    );
  }
}
