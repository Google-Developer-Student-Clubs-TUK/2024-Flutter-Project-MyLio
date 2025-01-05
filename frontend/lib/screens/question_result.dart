import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class QuestionResult extends StatefulWidget {
  final List<String> questions; // 외부에서 전달받는 질문 리스트
  const QuestionResult({super.key, required this.questions});

  @override
  _QuestionResultState createState() => _QuestionResultState();
}



class _QuestionResultState extends State<QuestionResult> {
  int _selectedQuestion = 0; // 첫 번째 질문을 선택

  late List<TextEditingController> _answerControllers;
  late List<int> _currentTextLengths;

  @override
  void initState(){
    super.initState();
    _answerControllers = List.generate(
        widget.questions.length, (index) => TextEditingController());
    _currentTextLengths = List.generate(
        widget.questions.length, (index) => 0);
  }

  @override
  void dispose() {
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
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


            // 상단 숫자 버튼
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
                            _currentTextLengths[_selectedQuestion] = text.length;
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
                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
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


