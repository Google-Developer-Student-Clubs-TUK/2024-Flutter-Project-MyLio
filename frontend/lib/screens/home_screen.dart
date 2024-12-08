import 'package:flutter/material.dart';
import 'introduction_list.dart';
import 'app_colors.dart';
import 'question_insert.dart';
import 'setting_screen.dart';
import 'widgets/bottom_bar.dart';

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
          child: Image.asset(
            'assets/images/logo.png',
            width: 154,
            height: 154,
            fit: BoxFit.cover,
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IntroductionList()),
          );
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

