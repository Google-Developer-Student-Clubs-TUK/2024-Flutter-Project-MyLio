
import 'package:flutter/material.dart';
import '../../utils/http_interceptor.dart';
import 'question_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuestionInsert extends StatefulWidget {
  const QuestionInsert({Key? key}) : super(key: key);

  @override
  State<QuestionInsert> createState() => _QuestionInsertState();
}

class _QuestionInsertState extends State<QuestionInsert> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final List<TextEditingController> questionControllers = [
    TextEditingController()
  ];



  bool _isLoading = false;


  final userId = "1";
  final baseUrl = dotenv.env['API_BASE_URL'] ?? "";

  /// ✅ 인터셉터 사용
  final HttpInterceptor httpInterceptor = HttpInterceptor();

  /// ✅ HTTP 요청: API 호출 시 인터셉터 사용
  Future<List<String>> _fetchAnswers(String title, List<String> questions) async {
    final url = Uri.parse('$baseUrl/api/v1/coverLetters/gen/$userId');

    try {
      final response = await httpInterceptor.post(
        url,
        body: {
          "userId": userId,
          "title": title,
          "questions": questions,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final questionAnswers = List<Map<String, dynamic>>.from(data['questionAnswers']);
        return questionAnswers.map((qa) => qa['answer'].toString()).toList();
      } else {
        throw Exception('Failed with status code: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
      return ['답변 테스트 1', '답변 테스트 2'];
    }
  }

  void _handleSubmit() async {
    if (titleController.text.trim().isEmpty ||
        questionControllers.any((controller) => controller.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    final title = titleController.text.trim();
    final companyName = companyNameController.text.trim();
    final jobTitle = jobTitleController.text.trim();
    final questions = questionControllers.map((controller) => controller.text.trim()).toList();

    setState(() {
      _isLoading = true;
    });



    try {
      final answers = await _fetchAnswers(title, questions);

      if (answers.isEmpty) {
        throw Exception('서버에서 답변을 생성하지 못했습니다.');
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionResult(
            title: title.isNotEmpty ? title : '제목 없음',
            questions: questions.isNotEmpty ? questions : ['질문 없음'],
            companyName: companyName,
            jobTitle: jobTitle,
            answers: answers,
          ),
        ),
      );
    } catch (e) {
      print('Error occurred during submission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('답변 생성 중 오류가 발생했습니다.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  // UI 및 TextField 생성 코드는 기존과 동일합니다.
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF908CFF)),
            ),
          ),
        ),
      ],
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
          '자기소개서 추가',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                const Center(
                  child: Column(
                    children: [
                      Text(
                        '자기소개서 문항 입력',
                        style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '자기소개서 문항은 최대 5개까지 입력이 가능하며,\n1000자 이내로 답변을 해줍니다.',
                        style: TextStyle(fontSize: 14, color: Color(0xff555555), fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: '회사명',
                        hint: '회사명을 입력해주세요.',
                        controller: companyNameController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: '직무명',
                        hint: '직무명을 입력해주세요.',
                        controller: jobTitleController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: '자기소개서 제목',
                  hint: '제목을 입력해주세요.',
                  controller: titleController,
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questionControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildTextField(
                        label: '자기소개서 문항 ${index + 1}',
                        hint: '문항을 입력해주세요.',
                        controller: questionControllers[index],
                      ),
                    );
                  },
                ),
                if (questionControllers.length < 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          questionControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add, color: Color(0xFF908CFF)),
                      label: const Text(
                        '문항 추가',
                        style: TextStyle(color: Color(0xFF908CFF), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: const BorderSide(color: Color(0xFF908CFF), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF908CFF),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '입력 완료',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

