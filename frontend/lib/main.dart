import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:frontend/screens/Login.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 시스템 초기화

  // .env 파일 로드
  try {
    final envPath = File('.env').absolute.path;
    print('Env file path: $envPath');
    await dotenv.load(fileName: ".env");
    print("dotenv 로드 성공: ${dotenv.env}");
  } catch (e) {
    print("dotenv 로드 실패: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash', // 초기 화면
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/home', page: () => const HomeScreen()),
      ],
    );
  }
}
