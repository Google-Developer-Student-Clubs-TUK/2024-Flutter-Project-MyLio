import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModifyCoverletter extends StatefulWidget {
  final Map<String, dynamic> introduction;

  const ModifyCoverletter({Key? key, required this.introduction}) : super(key: key);

  @override
  State<ModifyCoverletter> createState() => _ModifyIntroductionState();
}

class _ModifyIntroductionState extends State<ModifyCoverletter> {
  late TextEditingController titleController;
  late TextEditingController companyController;
  late TextEditingController jobTitleController;
  late List<TextEditingController> questionControllers;
  late List<TextEditingController> answerControllers;
  final baseUrl = dotenv.env['API_BASE_URL'];
  final accessToken = dotenv.env['ACCESS_TOKEN'];
  final userId = '1';

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.introduction['title']);
    companyController = TextEditingController(text: widget.introduction['company']);
    jobTitleController = TextEditingController(text: widget.introduction['jobTitle']);

    final questions = widget.introduction['questions'] as List<String>;
    final answers = widget.introduction['answers'] as List<String>;

    questionControllers = questions.map((q) => TextEditingController(text: q)).toList();
    answerControllers = answers.map((a) => TextEditingController(text: a)).toList();
  }

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    jobTitleController.dispose();
    for (var controller in questionControllers) {
      controller.dispose();
    }
    for (var controller in answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updatedIntroduction = {
      'id': widget.introduction['id'], // 기존 ID 유지
      'title': titleController.text.trim(),
      'company': companyController.text.trim(),
      'jobTitle': jobTitleController.text.trim(),
      'questions': questionControllers.map((c) => c.text.trim()).toList(),
      'answers': answerControllers.map((c) => c.text.trim()).toList(),
    };

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/v1/coverletters/$userId/${widget.introduction['id']}'),
        headers: {
          'Authorization': '$accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedIntroduction),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, updatedIntroduction); // 성공 시 데이터 반환
      } else {
        throw Exception('Failed to update introduction: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수정 중 오류 발생: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자기소개서 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: '제목'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: companyController,
              decoration: const InputDecoration(labelText: '회사명'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: jobTitleController,
              decoration: const InputDecoration(labelText: '직무명'),
            ),
            const SizedBox(height: 16),
            const Text('질문 및 답변'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questionControllers.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: questionControllers[index],
                      decoration: InputDecoration(labelText: '질문 ${index + 1}'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: answerControllers[index],
                      decoration: InputDecoration(labelText: '답변 ${index + 1}'),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('저장하기'),
            ),
          ],
        ),
      ),
    );
  }
}
