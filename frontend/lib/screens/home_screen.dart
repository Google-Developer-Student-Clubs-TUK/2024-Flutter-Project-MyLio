import 'package:flutter/material.dart';
import 'introduction_list.dart';
import 'theme/app_colors.dart';
import 'question_insert.dart';
import 'setting_screen.dart';
import 'components/bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('도움말'),
        content: const Text(
          'MyLio는 이력서 기반으로 AI가 \n 자기소개서를 생성해주는 서비스 입니다. \n\n'
          '중앙에 + 버튼을 누르면, 자기소개서를 생성해줍니다. \n\n '
          '왼쪽 아이콘에서 자기소개서 목록을 확인할 수 있으며, 오른쪽 아이콘에서는 이력서를 생성할 수 있습니다. ',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고에 Gradient(ShaderMask) 적용
            ShaderMask(
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
            const SizedBox(height: 16),

            // 말풍선 모양 또는 안내 박스
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 16),
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(8),
            //     boxShadow: const [
            //       BoxShadow(
            //         color: Colors.black12,
            //         blurRadius: 4,
            //         offset: Offset(0, 2),
            //       ),
            //     ],
            //   ),
            //   child: const Text(
            //     'MyLio는 이력서 기반으로 \n AI가 자기소개서를 생성해주는 서비스 입니다.\n'
            //     '중앙에 + 버튼을 누르면, 자기소개서를 생성해줍니다. \n '
            //     '왼쪽 아이콘에서 자기소개서 목록을 확인할 수 있으며,  \n'
            //     '오른쪽 아이콘에서는 이력서를 생성할 수 있습니다. ',
            //     style: TextStyle(fontSize: 14, color: Colors.black),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
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
        isHomeScreen: true,
        onLeftIconPressed: () {
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
