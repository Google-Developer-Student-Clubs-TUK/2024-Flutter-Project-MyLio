import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/screens/Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후 Login 화면으로 이동
    Timer(const Duration(seconds: 3), () {
      Get.off(() => Login());
    });
  }

  @override
  Widget build(BuildContext context) {
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
