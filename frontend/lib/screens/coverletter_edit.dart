import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class CoverLetterEdit extends StatefulWidget {
  final List<String> questions; // 외부에서 전달받는 질문 리스트

  const CoverLetterEdit(
      {super.key, required this.questions, required String resumeTitle});

  @override
  _CoverLetterEditState createState() => _CoverLetterEditState();
}

class _CoverLetterEditState extends State<CoverLetterEdit> {
  int _selectedQuestion = 0; // 첫 번째 질문을 선택

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
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 48),

            // 현재 질문 텍스트
            Text(
              widget.questions.isNotEmpty
                  ? '[필수] ${widget.questions[_selectedQuestion]}'
                  : '[필수] 질문이 없습니다.',
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
                      child: Text(
                        "여기에 ${_selectedQuestion + 1}번 질문에 대한 GPT 답변이 표시됩니다.",
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xff888888)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // 🔹 "되돌아가기" 버튼을 왼쪽 정렬
                      TextButton(
                        onPressed: _selectedQuestion > 0
                            ? () {
                                setState(() {
                                  _selectedQuestion--;
                                });
                              }
                            : null, // 첫 번째 질문일 때 비활성화
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // 기본 패딩 제거
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.rotate_left,
                                color: Colors.black, size: 20),
                            const SizedBox(width: 4), // 아이콘과 텍스트 간격
                            const Text(
                              '이전으로',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 🔹 빈 공간을 차지하는 Expanded 추가
                      Expanded(child: Container()),

                      // 🔹 "0/1000자"를 오른쪽 정렬
                      const Text(
                        '0/1000자',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8978EB),
                          fontWeight: FontWeight.normal,
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
                SizedBox(
                  width: 120,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {}); // 화면 갱신
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('답변 입력이 초기화되었습니다.'),
                          duration: Duration(seconds: 1),
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
                      '답변 재생성',
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
                      '저장하기',
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
