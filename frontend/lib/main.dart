import 'package:flutter/material.dart';
import 'splash_screen.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';


void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  // // 스플래시 화면 제거
  // FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // appBarTheme: const AppBarTheme(
        //   backgroundColor: Colors.white, // 전역 앱바 배경색
        //   elevation: 1, // 전역 앱바 그림자
        //   shadowColor: Colors.grey, // 전역 그림자 색상
        // ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // SplashScreen을 첫 화면으로 설정
      home: const SplashScreen(),
    );
  }
}
