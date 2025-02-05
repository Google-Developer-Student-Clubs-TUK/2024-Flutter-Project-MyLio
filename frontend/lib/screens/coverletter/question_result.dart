

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/theme/app_colors.dart';
import 'package:http/http.dart' as http;
import '../../utils/http_interceptor.dart';
import 'coverLetter_list.dart';

class QuestionResult extends StatefulWidget {
  final String title;
  final String companyName;
  final String jobTitle;
  final List<String> questions; // 외부에서 전달받는 질문 리스트
  final List<String> answers;
  const QuestionResult({super.key,
    required this.title,
    required this.companyName,
    required this.jobTitle,
    required this.questions,
    required this.answers
  });

  @override
  _QuestionResultState createState() => _QuestionResultState();
}



class _QuestionResultState extends State<QuestionResult> {
  int _selectedQuestion = 0;
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

  /// ✅ 인터셉터 인스턴스 생성
  final HttpInterceptor httpInterceptor = HttpInterceptor();

  late List<TextEditingController> _answerControllers;
  late List<int> _currentTextLengths;
  late List<String> savedAnswers;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// ✅ 자소서 저장 API 요청 (HttpInterceptor 사용)
  Future<void> _saveCoverLetter() async {
    final answers = _answerControllers.map((controller) => controller.text.trim()).toList();

    final emptyIndex = answers.indexWhere((answer) => answer.isEmpty);
    if (emptyIndex != -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${emptyIndex + 1}번 질문의 답변을 입력해주세요.')),
      );
      return;
    }

    final introduction = {
      'title': widget.title,
      'company': widget.companyName,
      'jobTitle': widget.jobTitle,
      'questions': widget.questions,
      'answers': answers,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await httpInterceptor.post(
        Uri.parse('$baseUrl/api/v1/coverLetters/save'),
        body: introduction,
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CoverLetterList()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('제출 완료')),
        );
      } else {
        print("HTTP error ${response.statusCode}");
        print("Error Response Body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: ${response.body}')),
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


            // 상단 숫자(질문 선택) 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                widget.questions.length,
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
                    if (_selectedQuestion != index){
                      setState(() {
                        _selectedQuestion = index;
                      });
                    }
                    // setState(() {
                    //   _selectedQuestion = index;
                    // });
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
                  fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
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
                          onChanged: (text) {
                            setState(() {
                              if (text.length > 1000) {
                                _answerControllers[_selectedQuestion].text = text.substring(0, 1000); // 1000자 제한
                                _answerControllers[_selectedQuestion].selection = TextSelection.fromPosition(
                                  TextPosition(offset: 1000),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('1000자를 초과할 수 없습니다.'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                              _currentTextLengths[_selectedQuestion] = text.length.clamp(0, 1000); // 글자 수 업데이트
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${_selectedQuestion + 1}번 질문에 대한 답변을 입력해주세요.',
                            hintStyle: TextStyle(fontSize: 14, color: Color(0xff888888)),
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 8),

                  // 글자 수 카운트와 새로고침 버튼
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


                      // 새로고침 버튼
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _answerControllers[_selectedQuestion].clear(); // 선택된 질문 초기화
                            _currentTextLengths[_selectedQuestion] = 0;   // 글자 수 초기화
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('답변 입력이 초기화되었습니다.',),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh, color: AppColor.color2,),
                        color: AppColor.color2,
                        iconSize: 20, // 아이콘 크기
                        padding: const EdgeInsets.all(0), // 여백 제거
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ), // 크기 제한
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


                SizedBox(
                  width: 120,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      final answer = _answerControllers[_selectedQuestion].text.trim();

                      if (answer.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${_selectedQuestion + 1}번 질문의 답변을 입력해주세요.'),
                              duration: const Duration(seconds: 1),
                            )
                        );
                        return;
                      }


                      setState(() {
                        savedAnswers[_selectedQuestion] = answer;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${_selectedQuestion + 1}번 질문이 저장되었습니다.'),
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


                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final answers = _answerControllers.map((controller) => controller.text.trim()).toList();

                      final emptyIndex = answers.indexWhere((answer) => answer.isEmpty);
                      if (emptyIndex != -1){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${emptyIndex + 1}번 질문의 답변을 입력해주세요.'))
                        );
                        return;
                      }

                      final introduction = {
                        'title': widget.title,
                        'company': widget.companyName,
                        'jobTitle': widget.jobTitle,
                        'questions': widget.questions,
                        'answers': answers,
                      };

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          )
                      );

                      try {
                        // ✅ HttpInterceptor를 사용해 요청 전송
                        final response = await httpInterceptor.post(
                          Uri.parse('$baseUrl/api/v1/coverLetters/save'), // API URL
                          body: introduction, // JSON 데이터 자동 변환됨
                        );

                        Navigator.pop(context); // 로딩 다이얼로그 닫기

                        if (response.statusCode == 200) {
                          // ✅ 저장 성공 시 CoverLetterList 화면으로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => CoverLetterList()),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('제출 완료')),
                          );
                        }
                        else {
                          print("HTTP error ${response.statusCode}");
                          print("Error Response Body: ${response.body}");

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('저장 실패: ${response.body}')),
                          );
                        }
                        }

                        catch (e) {
                          Navigator.pop(context); // 로딩 다이얼로그 닫기
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('오류 발생: $e')),
                          );
                        }
                      },




                      /*
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IntroductionList(
                            introductions: [introduction],
                          ),
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('제출 완료')),
                      );

                       */


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
}

