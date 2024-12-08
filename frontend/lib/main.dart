import 'package:flutter/material.dart';
import 'package:frontend/screens/Login.dart';
import 'package:frontend/screens/home_screen.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // GetMaterialApp으로 변경
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // SplashScreen을 첫 화면으로 설정
      home: const SplashScreen(),
      getPages: [
        // 페이지 라우팅
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/login', page: () => Login()),
        // GetPage(name: '/signup', page: () => Signup()),
      ],
    );
  }
}
