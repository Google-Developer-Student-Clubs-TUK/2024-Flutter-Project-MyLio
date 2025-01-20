// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'app_colors.dart';
// import 'introduction_list.dart';
//
// class QuestionResult extends StatefulWidget {
//   final String companyName; // 회사명
//   final String position; // 직무명
//   final List<String> questions; // 질문 목록
//
//   const QuestionResult({
//     super.key,
//     required this.companyName,
//     required this.position,
//     required this.questions,
//   });
//
//   @override
//   _QuestionResultState createState() => _QuestionResultState();
// }
//
// class _QuestionResultState extends State<QuestionResult> {
//   final Map<String, String> answers = {}; // 질문-답변 매핑
//   int _selectedQuestion = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             size: 24,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // 상단 질문 선택 버튼
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 widget.questions.length,
//                     (index) => Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       shape: const CircleBorder(),
//                       side: BorderSide(
//                         color: _selectedQuestion == index
//                             ? AppColor.color2
//                             : Colors.grey,
//                       ),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _selectedQuestion = index;
//                       });
//                     },
//                     child: Text(
//                       '${index + 1}',
//                       style: TextStyle(
//                         color: _selectedQuestion == index
//                             ? AppColor.color2
//                             : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // 질문 텍스트
//             Text(
//               '[필수] ${widget.questions[_selectedQuestion]}',
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // 답변 입력 박스
//             Expanded(
//               child: TextField(
//                 maxLines: null,
//                 onChanged: (value) {
//                   answers[widget.questions[_selectedQuestion]] = value;
//                 },
//                 decoration: InputDecoration(
//                   hintText: '답변을 입력해주세요.',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide: const BorderSide(color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // 하단 버튼
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // 끝내기 버튼
//                 ElevatedButton(
//                   onPressed: (){},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColor.color2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   child: const Text(
//                     '끝내기',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class QuestionResult extends StatefulWidget {
  final List<String> questions; // 외부에서 전달받는 질문 리스트

  const QuestionResult({super.key, required this.questions});

  @override
  _QuestionResultState createState() => _QuestionResultState();
}

class _QuestionResultState extends State<QuestionResult> {
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
                      child: Text(
                        "여기에 ${_selectedQuestion + 1}번 질문에 대한 GPT 답변이 표시됩니다.",
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xff888888)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 글자 수 카운트와 새로고침 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        '0/1000자',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8978EB),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      // 새로고침 버튼
                      IconButton(
                        onPressed: () {
                          // 새로고침 버튼 클릭 시 동작
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '답변 입력이 초기화되었습니다.',
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: AppColor.color2,
                        ),
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
