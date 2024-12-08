import 'package:flutter/material.dart';
import 'package:frontend/screens/app_colors.dart';
import 'package:frontend/screens/question_insert.dart';
import 'package:frontend/screens/setting_screen.dart';
import 'package:frontend/screens/widgets/bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'AI 자기소개서',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(), // 빈 컨테이너로 대체
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Gradients.blue.withOpacity(0.5),
              Gradients.purple.withOpacity(0.5),
              Gradients.pink.withOpacity(0.5),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ).createShader(bounds),
          child: const Icon(
            Icons.all_inclusive,
            size: 155,
            color: Colors.white, // ShaderMask가 이 색상을 덮어씀
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 70.0,
        width: 70.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Gradients.blue,
              Gradients.purple,
              Gradients.pink,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuestionInsert()),
            );
          },
          elevation: 0, // 기본 그림자 제거
          highlightElevation: 0, // 클릭 시 그림자 제거
          hoverElevation: 0, // 마우스 오버 시 그림자 제거
          focusElevation: 0, // 포커스 시 그림자 제거
          backgroundColor: Colors.transparent, // 배경 투명 처리
          child: const Icon(Icons.add, size: 41, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBar(
        onGridPressed: () {
          print('Grid button pressed');
        },
        onSettingsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingScreen()),
          );
        },
        onFabPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuestionInsert()),
          );
        },
      ),
    );
  }
}
