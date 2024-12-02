import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 3초 후 HomeScreen 화면으로 이동
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // 화면에 꽉 차도록 설정
        children: [
          Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover, // 이미지가 화면을 채우도록 설정
          ),
        ],
      ),
    );
  }
}
