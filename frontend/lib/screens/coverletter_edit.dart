import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'theme/app_colors.dart';

class CoverLetterEdit extends StatefulWidget {
  final String resumeTitle;
  final List<dynamic>? questions; // 외부에서 질문 데이터를 전달할 수 있도록 추가

  const CoverLetterEdit({
    super.key,
    required this.resumeTitle,
    this.questions,
  });

  @override
  _CoverLetterEditState createState() => _CoverLetterEditState();
}

class _CoverLetterEditState extends State<CoverLetterEdit> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  List<dynamic> questions = [];
  int _selectedQuestion = 0;
  bool isLoading = true;

  // TextField에 연결할 컨트롤러 추가
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 컨트롤러에 리스너 추가: 글자수 변화 감지
    _answerController.addListener(() {
      setState(() {});
    });

    // 만약 외부에서 questions가 전달되었다면 API 호출 없이 그대로 사용
    if (widget.questions != null) {
      questions = widget.questions!;
      isLoading = false;
    } else {
      fetchCoverLetter();
    }
    // 초기 컨트롤러 텍스트 설정
    _answerController.text =
        questions.isNotEmpty ? questions[_selectedQuestion]['answer'] : '';
  }

  Future<void> fetchCoverLetter() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("❌ API_BASE_URL 환경 변수가 설정되지 않았습니다.");
      return;
    }

    final String? userId = await secureStorage.read(key: "user_id");
    if (userId == null) {
      print("❌ 저장된 user_id를 찾을 수 없습니다.");
      return;
    }

    final url = Uri.parse("$baseUrl/api/v1/coverLetters/user/$userId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> coverLetters = jsonDecode(decodedBody);

        if (coverLetters.isNotEmpty) {
          setState(() {
            questions = coverLetters[0]['questionAnswers'] ?? [];
            isLoading = false;
            _answerController.text = questions.isNotEmpty
                ? questions[_selectedQuestion]['answer']
                : '';
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("❌ API 호출 실패: ${response.statusCode} - ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ 네트워크 오류: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
            // 상단 숫자 버튼 (questions 배열 길이 만큼 생성)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                questions.length,
                (index) => OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(
                      color: AppColor.color2,
                      width: 2,
                    ),
                    backgroundColor: _selectedQuestion == index
                        ? AppColor.color2
                        : Colors.transparent,
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedQuestion = index;
                      // 질문 선택 시 컨트롤러 텍스트 업데이트
                      _answerController.text = questions.isNotEmpty
                          ? questions[_selectedQuestion]['answer']
                          : '';
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
            const Text(
              "번호를 클릭해서 생성된 답변들을 확인해 주세요.\n만약 답변이 마음에 들지 않는다면, 새로고침을 해주세요.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 48),
            // 현재 질문 텍스트 (questions 배열의 question 값 사용)
            Text(
              questions.isNotEmpty
                  ? '[필수] ${questions[_selectedQuestion]['question']}'
                  : '[필수] 질문이 없습니다.',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xff888888),
              ),
            ),
            const SizedBox(height: 16),
            // 답변 입력 박스 (수정 가능한 TextField로 변경)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _answerController,
                  maxLines: null,
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xff888888)),
                  decoration: InputDecoration(
                    hintText:
                        "여기에 ${_selectedQuestion + 1}번 질문에 대한 GPT 답변이 생성 중 입니다.",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    if (questions.isNotEmpty) {
                      questions[_selectedQuestion]['answer'] = value;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // "이전으로" 버튼 (첫 번째 질문일 경우 비활성화)
                TextButton(
                  onPressed: _selectedQuestion > 0
                      ? () {
                          setState(() {
                            _selectedQuestion--;
                            _answerController.text = questions.isNotEmpty
                                ? questions[_selectedQuestion]['answer']
                                : '';
                          });
                        }
                      : null,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.rotate_left,
                          color: Color(0xff444444), size: 20),
                      SizedBox(width: 4),
                      Text(
                        '이전으로',
                        style: TextStyle(
                          color: Color(0xff444444),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                // 입력된 글자 수에 따른 카운트 표시
                Text(
                  "${_answerController.text.length}/1000자",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8978EB),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 하단 버튼들 (Expanded 위젯을 사용해 좌우 꽉 차게 변경)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        // 답변 재생성: 현재 질문의 answer를 빈 문자열로 초기화하고 컨트롤러도 초기화
                        setState(() {
                          questions[_selectedQuestion]['answer'] = "";
                          _answerController.text = "";
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('답변 입력이 초기화되었습니다.'),
                            duration: Duration(seconds: 1),
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
                        '답변 재생성',
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
                      onPressed: () {
                        // 저장하기 버튼 클릭 시 수정된 데이터를 API로 전송하는 로직 추가 가능
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('제출 완료'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.color2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '저장하기',
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
