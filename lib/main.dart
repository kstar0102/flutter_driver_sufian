
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
import 'package:flutter/material.dart';

import 'home_trips.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
    Timer(const Duration(seconds: 2),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => const MyLogin()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/splash.jpg"), fit: BoxFit.cover)
      ),
    );
  }
}


