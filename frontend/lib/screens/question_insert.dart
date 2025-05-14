import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as _storage;
import 'package:http/http.dart' as _api;
import '../../../utils/http_interceptor.dart';
import 'loading_screen.dart';
import 'question_result.dart';
import 'dart:convert';

class QuestionInsert extends StatefulWidget {
  const QuestionInsert({Key? key}) : super(key: key);
  @override
  State<QuestionInsert> createState() => _QuestionInsertState();
}

class _QuestionInsertState extends State<QuestionInsert> {
  final titleController = TextEditingController();
  final companyController = TextEditingController();
  final jobController = TextEditingController();
  final questionControllers = <TextEditingController>[TextEditingController()];

  String? _userId;
  final _storage = const FlutterSecureStorage();
  final _api = HttpInterceptor();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    // key 매개변수 사용 원본 유지
    final id = await _storage.read(key: 'user_id');
    if (id != null) setState(() => _userId = id);
  }

  Future<Uri> _makeUri(String path) async {
    final base = dotenv.env['API_BASE_URL'];
    if (base == null) throw Exception('API_BASE_URL not set');
    return Uri.parse('$base$path');
  }

  Future<Map<String, dynamic>> _fetchAnswers(
      String title,
      String company,
      String job,
      List<String> questions,
      ) async {
    if (_userId == null) throw Exception('USER_ID missing');

    final uri = await _makeUri('/api/v1/coverLetters/gen');
    final response = await _api.post(
      uri,
      body: {
        'userId': _userId,
        'title': title,
        'companyName': company,
        'jobTitle': job,
        'questions': questions,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('API error: \${response.statusCode}');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return {
      'coverLetterId': data['coverLetterId'] ?? '',
      'answers': (data['questionAnswers'] as List)
          .map((qa) => qa['answer'].toString())
          .toList(),
    };
  }

  void _handleSubmit() {
    if (_userId == null ||
        titleController.text.trim().isEmpty ||
        questionControllers.any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }
    final title = titleController.text.trim();
    final company = companyController.text.trim();
    final job = jobController.text.trim();
    final questions = questionControllers.map((c) => c.text.trim()).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoadingScreen(
          title: title,
          companyName: company,
          jobTitle: job,
          questions: questions,
        ),
      ),
    );
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
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '자기소개서 문항은 최대 5개까지 입력이 가능하며,\n1000자 이내로 답변을 해줍니다.',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff555555),
                            fontWeight: FontWeight.w500),
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
                        hint: 'ex)GDSC',
                        controller: companyController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: '직무명',
                        hint: 'ex)개발',
                        controller: jobController,
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
                        style: TextStyle(
                            color: Color(0xFF908CFF),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: const BorderSide(
                            color: Color(0xFF908CFF), width: 1),
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
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
