import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'home.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        nextScreen: Home(),
        animationDuration: Duration(milliseconds: 400),
        centered: true,
        splashIconSize: 200,
        backgroundColor: Colors.white,
        splash: Container(
          child: Image.asset("assets/images/splash.jpg"),
        ),

      ),
    );
  }
}
