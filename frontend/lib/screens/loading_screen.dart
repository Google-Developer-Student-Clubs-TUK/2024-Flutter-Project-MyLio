import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/theme/app_colors.dart';
import '../../../utils/http_interceptor.dart';
import 'question_result.dart';

class LoadingScreen extends StatefulWidget {
  final String title;
  final String companyName;
  final String jobTitle;
  final List<String> questions;
  final String userId;

  const LoadingScreen({
    super.key,
    required this.title,
    required this.companyName,
    required this.jobTitle,
    required this.questions,
    required this.userId,
  });

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final HttpInterceptor httpInterceptor = HttpInterceptor();
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

  @override
  void initState() {
    super.initState();

    // 애니메이션 초기화
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // API 호출 후 결과 페이지로 이동
    _fetchAnswers();
  }

  /// ✅ GPT API 호출
  Future<void> _fetchAnswers() async {
    final url = Uri.parse('$baseUrl/api/v1/coverLetters/gen/${widget.userId}');

    try {
      final response = await httpInterceptor.post(
        url,
        body: {
          "userId": widget.userId,
          "title": widget.title,
          "questions": widget.questions,
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);

        final coverLetterId = data['coverLetterId'].toString() ?? '';
        final questionAnswers =
            List<Map<String, dynamic>>.from(data['questionAnswers']);
        final answers =
            questionAnswers.map((qa) => qa['answer'].toString()).toList();

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionResult(
                title: widget.title,
                companyName: widget.companyName,
                jobTitle: widget.jobTitle,
                questions: widget.questions,
                answers: answers,
                coverLetterId: coverLetterId,
              ),
            ),
          );
        }
      } else {
        throw Exception('서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('API 요청 실패: $e');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionResult(
              title: widget.title,
              companyName: widget.companyName,
              jobTitle: widget.jobTitle,
              questions: widget.questions,
              answers: ['오류 발생: 답변을 가져올 수 없음'],
              coverLetterId: '',
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
                    Gradients.purple,
                    Gradients.pink,
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
