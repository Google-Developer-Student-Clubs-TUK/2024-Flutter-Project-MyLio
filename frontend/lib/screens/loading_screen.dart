import 'dart:math';
import 'question_result.dart';
import 'theme/app_colors.dart';
import 'package:flutter/material.dart';

// 로딩 화면
class LoadingScreen extends StatefulWidget {
  final String title;
  final String companyName;
  final String jobTitle;
  final List<String> questions;
  final List<String> answers;
  final String coverLetterId;

  const LoadingScreen({
    super.key,
    required this.title,
    required this.companyName,
    required this.jobTitle,
    required this.questions,
    required this.answers,
    required this.coverLetterId
  });

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // AnimationController 초기화 (2초 동안 반복)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(); // 무한 반복

    // 2초 후 결과 화면으로 이동
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionResult(
            title: widget.title,
            companyName: widget.companyName,
            jobTitle: widget.jobTitle,
            questions: widget.questions,
            answers: widget.answers,
            coverLetterId: widget.coverLetterId,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // 메모리 누수를 방지하기 위해 dispose 호출
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AnimatedBuilder로 애니메이션 적용
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi, // 0 ~ 2π 회전
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/logo.png',
                width: 92,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [
                    // Gradients.blue,
                    Gradients.purple,
                    Gradients.pink
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: const Text(
                'Loading...',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
