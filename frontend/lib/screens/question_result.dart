import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/theme/app_colors.dart';
import '../../../utils/http_interceptor.dart';

class QuestionResult extends StatefulWidget {
  final String title;
  final String companyName;
  final String jobTitle;
  final List<String> questions;
  final List<String> answers;
  final String coverLetterId;

  const QuestionResult({
    Key? key,
    required this.title,
    required this.companyName,
    required this.jobTitle,
    required this.questions,
    required this.answers,
    required this.coverLetterId,
  }) : super(key: key);

  @override
  _QuestionResultState createState() => _QuestionResultState();
}

class _QuestionResultState extends State<QuestionResult> {
  int _selectedQuestion = 0;
  final HttpInterceptor _api = HttpInterceptor();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _userId;

  late final List<TextEditingController> _answerControllers;
  late final List<int> _currentTextLengths;
  late final List<String> _savedAnswers;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _answerControllers = List.generate(
      widget.questions.length,
          (i) => TextEditingController(text: widget.answers[i]),
    );
    _currentTextLengths = List.generate(
      widget.questions.length,
          (i) => widget.answers[i].length,
    );
    _savedAnswers = List.from(widget.answers);
  }

  Future<void> _loadUserId() async {
    final id = await _storage.read(key: 'user_id');
    if (id != null) {
      setState(() => _userId = id);
    }
  }

  Future<void> _saveTempCoverLetter() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자 정보를 불러오지 못했습니다.')),
      );
      return;
    }
    final base = dotenv.env['API_BASE_URL'];
    final uri = Uri.parse(
      '$base/api/v1/coverLetters/copy/${widget.coverLetterId}',
    );
    try {
      final res = await _api.put(uri);
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('임시 저장 완료')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('임시 저장 실패: ${res.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  Future<void> _saveCoverLetter() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자 정보를 불러오지 못했습니다.')),
      );
      return;
    }
    final answers = _answerControllers
        .map((c) => c.text.trim())
        .toList();
    final body = jsonEncode({
      'title': widget.title,
      'company': widget.companyName,
      'jobTitle': widget.jobTitle,
      'questions': widget.questions,
      'answers': answers,
    });
    final base = dotenv.env['API_BASE_URL'];
    final uri = Uri.parse(
      '$base/api/v1/coverLetters/${widget.coverLetterId}',
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final res = await _api.put(uri, body: body);
      Navigator.pop(context);
      if (res.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('최종 저장 완료')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('최종 저장 실패: ${res.body}')),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  @override
  void dispose() {
    for (var c in _answerControllers) {
      c.dispose();
    }
    super.dispose();
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
              "번호를 클릭해서 생성된 답변들을 확인해 주세요.\n만약 답변이 마음에 들지 않는다면, 새로고침을 해주세요.",
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
                          hintText:
                              '${_selectedQuestion + 1}번 질문에 대한 답변을 입력해주세요.',
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

            // 하단 버튼 (임시저장, 끝내기) - 좌우 꽉 차도록 Expanded 사용
            Row(
              children: [
                Expanded(
                  child: SizedBox(
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
                          _savedAnswers[_selectedQuestion] = answer;
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
                        side:
                            const BorderSide(color: AppColor.color2, width: 2),
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
