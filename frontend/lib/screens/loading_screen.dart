import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/screens/theme/app_colors.dart';
import '../../../utils/http_interceptor.dart';
import 'question_result.dart';

class LoadingScreen extends StatefulWidget {
  final String title, companyName, jobTitle;
  final List<String> questions;
  const LoadingScreen({Key? key,
    required this.title,
    required this.companyName,
    required this.jobTitle,
    required this.questions,
  }) : super(key: key);
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _storage = const FlutterSecureStorage();
  final _api = HttpInterceptor();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _fetchAnswers();
  }

  Future<Uri> _makeUri(String path) async {
    final base = dotenv.env['API_BASE_URL'];
    if (base == null) throw Exception('API_BASE_URL not set');
    return Uri.parse('$base$path');
  }

  Future<void> _fetchAnswers() async {
    final uri = await _makeUri('/api/v1/coverLetters/gen');
    try {
      final result = await _api.post(
        uri,
        body: {
          'userId': await _storage.read(key: 'user_id'),
          'title': widget.title,
          'companyName': widget.companyName,
          'jobTitle': widget.jobTitle,
          'questions': widget.questions,
        },
      );
      if (result.statusCode == 200) {
        final data = jsonDecode(utf8.decode(result.bodyBytes));
        final answers = (data['questionAnswers'] as List)
            .map((qa) => qa['answer'].toString())
            .toList();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuestionResult(
              title: widget.title,
              companyName: widget.companyName,
              jobTitle: widget.jobTitle,
              questions: widget.questions,
              answers: answers,
              coverLetterId: data['coverLetterId'].toString(),
            ),
          ),
        );
      } else {
        throw Exception('Server error');
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionResult(
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
