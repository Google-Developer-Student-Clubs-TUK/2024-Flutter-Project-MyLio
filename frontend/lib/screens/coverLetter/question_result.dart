import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/screens/theme/app_colors.dart';
import 'package:http/http.dart' as http;
import '../../../utils/http_interceptor.dart';
import '../introduction_list.dart';
import '../introduction_list.dart';

class QuestionResult extends StatefulWidget {
  final String title;
  final String companyName;
  final String jobTitle;
  final List<String> questions;
  final List<String> answers;
  final String coverLetterId; // ✅ coverLetterId 추가 (API 호출에 필요)

  QuestionResult({
    super.key,
    required this.title,
    required this.companyName,
    required this.jobTitle,
    required this.questions,
    required this.answers,
    required String coverLetterId,
  }): coverLetterId = coverLetterId.toString();

  @override
  _QuestionResultState createState() => _QuestionResultState();
}

class _QuestionResultState extends State<QuestionResult> {
  int _selectedQuestion = 0;
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";
  final HttpInterceptor httpInterceptor = HttpInterceptor();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? _userId; // ✅ secureStorage에서 가져올 userId

  late List<TextEditingController> _answerControllers;
  late List<int> _currentTextLengths;
  late List<String> savedAnswers;

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // ✅ userId 가져오기
    _answerControllers = List.generate(
      widget.questions.length,
          (index) => TextEditingController(text: widget.answers[index]),
    );

    _currentTextLengths = List.generate(
      widget.questions.length,
          (index) => widget.answers[index].length,
    );

    savedAnswers = List.generate(
      widget.questions.length,
          (index) => widget.answers[index],
    );
  }

  /// ✅ `secureStorage`에서 userId 가져오기
  Future<void> _loadUserInfo() async {
    String? userId = await secureStorage.read(key: "user_id");

    if (userId == null) {
      print("🚨 USER_ID가 없습니다.");
      return;
    }

    setState(() {
      _userId = userId;
    });

    print("✅ User ID: $_userId");
  }

  @override
  void dispose() {
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// ✅ 임시저장 API 호출 (PUT /copy/{userId}/{coverLetterId})
  Future<void> _saveTempCoverLetter() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자 정보를 불러오지 못했습니다. 다시 시도해주세요.')),
      );
      return;
    }

    final url = Uri.parse('$baseUrl/api/v1/coverLetters/copy/$_userId/${widget.coverLetterId}');

    try {
      final response = await httpInterceptor.put(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('임시 저장 완료')),
        );
      } else {
        print("HTTP error ${response.statusCode}");
        print("Error Response Body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('임시 저장 실패: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  /// ✅ 최종저장 API 호출 (PUT /{userId}/{coverLetterId})
  Future<void> _saveCoverLetter() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자 정보를 불러오지 못했습니다. 다시 시도해주세요.')),
      );
      return;
    }

    final answers = _answerControllers.map((controller) => controller.text.trim()).toList();

    final introduction = {
      'title': widget.title,
      'company': widget.companyName,
      'jobTitle': widget.jobTitle,
      'questions': widget.questions,
      'answers': answers,
    };

    final url = Uri.parse('$baseUrl/api/v1/coverLetters/$_userId/${widget.coverLetterId}');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await httpInterceptor.put(url, body: jsonEncode(introduction));

      Navigator.pop(context);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IntroductionList()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('최종 저장 완료')),
        );
      } else {
        print("HTTP error ${response.statusCode}");
        print("Error Response Body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('최종 저장 실패: ${response.body}')),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상단 질문 선택 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                widget.questions.length,
                    (index) => OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(color: AppColor.color2, width: 2),
                    backgroundColor: _selectedQuestion == index
                        ? AppColor.color2
                        : Colors.transparent,
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedQuestion = index;
                    });
                  },
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: _selectedQuestion == index
                          ? Colors.white
                          : AppColor.color2,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 안내문 텍스트
            const Text(
              "번호를 클릭해서 생성된 답변들을 확인해 주세요.\n"
                  "만약 답변이 마음에 들지 않는다면, 새로고침을 해주세요.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 48),

            // 현재 질문 텍스트
            Text(
              '[필수] ${widget.questions[_selectedQuestion]}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xff888888),
              ),
            ),
            const SizedBox(height: 16),

            // 답변 입력 박스
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _answerControllers[_selectedQuestion],
                        maxLines: null,
                        expands: true, // ✅ TextField 크기 자동 조절
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.top, // ✅ 텍스트 위 정렬
                        onChanged: (text) {
                          setState(() {
                            if (text.length > 1000) {
                              _answerControllers[_selectedQuestion].text =
                                  text.substring(0, 1000); // 1000자 제한
                              _answerControllers[_selectedQuestion].selection =
                                  TextSelection.fromPosition(
                                    TextPosition(offset: 1000),
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('1000자를 초과할 수 없습니다.'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                            _currentTextLengths[_selectedQuestion] =
                                text.length.clamp(0, 1000);
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '${_selectedQuestion + 1}번 질문에 대한 답변을 입력해주세요.',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff888888),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 글자 수 카운트 및 새로고침 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${_currentTextLengths[_selectedQuestion]}/1000자',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8978EB),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _answerControllers[_selectedQuestion].clear();
                            _currentTextLengths[_selectedQuestion] = 0;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('답변 입력이 초기화되었습니다.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh, color: AppColor.color2),
                        color: AppColor.color2,
                        iconSize: 20,
                        padding: const EdgeInsets.all(0),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 하단 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 임시저장 버튼
                SizedBox(
                  width: 120,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      final answer =
                      _answerControllers[_selectedQuestion].text.trim();

                      if (answer.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${_selectedQuestion + 1}번 질문의 답변을 입력해주세요.'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        savedAnswers[_selectedQuestion] = answer;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                          Text('${_selectedQuestion + 1}번 질문이 저장되었습니다.'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColor.color2, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '임시저장',
                      style: TextStyle(color: AppColor.color2, fontSize: 14),
                    ),
                  ),
                ),

                // 끝내기 버튼
                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _saveCoverLetter(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.color2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '끝내기',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  /*
  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 24, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 질문 선택 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                widget.questions.length,
                    (index) => OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(color: AppColor.color2, width: 2),
                    backgroundColor: _selectedQuestion == index ? AppColor.color2 : Colors.transparent,
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () => setState(() => _selectedQuestion = index),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: _selectedQuestion == index ? Colors.white : AppColor.color2,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 질문 텍스트
            Text(
              '[필수] ${widget.questions[_selectedQuestion]}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 답변 입력 박스
            Expanded(
              child: TextField(
                controller: _answerControllers[_selectedQuestion],
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '답변을 입력하세요',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 하단 버튼 (임시저장, 최종저장)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: _saveTempCoverLetter,
                  child: const Text('임시저장'),
                ),
                ElevatedButton(
                  onPressed: _saveCoverLetter,
                  child: const Text('최종저장'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

   */
}

