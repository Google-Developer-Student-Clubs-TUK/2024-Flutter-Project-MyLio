import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/coverletter_edit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../theme/app_colors.dart';

class IntroductionListPopupMenuBtn extends StatefulWidget {
  final String resumeTitle;
  final List<dynamic> coverLetters;
  final VoidCallback? onModifyPressed; // 수정 버튼 눌림에 대한 콜백

  const IntroductionListPopupMenuBtn({
    super.key,
    required this.resumeTitle,
    required this.coverLetters,
    this.onModifyPressed,
  });

  @override
  State<IntroductionListPopupMenuBtn> createState() =>
      _IntroductionListPopupMenuBtnState();
}

class _IntroductionListPopupMenuBtnState
    extends State<IntroductionListPopupMenuBtn> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  /// "미리보기" 다이얼로그 표시 함수
  /// - 선택한 coverLetter 정보를 서버에서 받아와 표시
  Future<void> _showPreviewDialog(BuildContext context) async {
    // 1) userId 읽기
    final String? userId = await secureStorage.read(key: "user_id");
    if (userId == null) {
      print("❌ 저장된 user_id를 찾을 수 없습니다.");
      return;
    }

    // 2) 현재 resumeTitle과 일치하는 coverLetter 찾기
    final selectedCoverLetter = widget.coverLetters.firstWhere(
      (coverLetter) => coverLetter['title'] == widget.resumeTitle,
      orElse: () => null,
    );
    if (selectedCoverLetter == null) {
      print("❌ 해당 자기소개서를 찾을 수 없습니다. (resumeTitle=${widget.resumeTitle})");
      print("coverLetters 전체: ${widget.coverLetters}");
      return;
    }

    // 3) coverLetterId 추출
    final coverLetterId = selectedCoverLetter['coverLetterId'];
    if (coverLetterId == null) {
      print("❌ coverLetterId가 없습니다. selectedCoverLetter: $selectedCoverLetter");
      return;
    }

    // 4) API_BASE_URL 가져오기
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("❌ API_BASE_URL 환경 변수가 설정되지 않았습니다.");
      return;
    }

    // 5) GET 요청 보내기
    final url =
        Uri.parse("$baseUrl/api/v1/coverLetters/$userId/$coverLetterId");
    print("미리보기 API 호출 URL: $url");

    Map<String, dynamic>? previewData;
    try {
      final response = await http.get(url);
      print("미리보기 API 응답 statusCode: ${response.statusCode}");

      // --- UTF-8 디코딩 추가 ---
      final decodedBody = utf8.decode(response.bodyBytes);
      print("미리보기 API 응답 body(디코딩 후): $decodedBody");

      if (response.statusCode == 200) {
        previewData = jsonDecode(decodedBody) as Map<String, dynamic>;
      } else {
        print("❌ 미리보기 실패! 상태 코드: ${response.statusCode}, 응답 본문: $decodedBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('미리보기 실패: $decodedBody'),
            duration: const Duration(seconds: 1),
          ),
        );
        return;
      }
    } catch (e) {
      print("❌ 네트워크 오류(미리보기): $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('네트워크 오류: $e'),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    // 데이터를 정상적으로 가져왔다면, 다이얼로그를 띄워서 내용 표시
    if (previewData == null) {
      print("❌ previewData가 null입니다.");
      return;
    }

    // questionAnswers 가져오기
    final questionAnswers =
        previewData['questionAnswers'] as List<dynamic>? ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 353,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    previewData?['title'] ?? "제목 없음",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...questionAnswers.map((qa) {
                    final question = qa['question'] ?? "질문 없음";
                    final answer = qa['answer'] ?? "답변 없음";
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q. $question",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "A. $answer",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.color2,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('닫기'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// "삭제하기" 다이얼로그
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 228,
            width: 353,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.resumeTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
                const SizedBox(height: 30),
                const Text(
                  '정말 삭제하시겠습니까?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.color2,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        print('Item Deleted');
                        // TODO: 실제 삭제 API 연동 로직 추가
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '예',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(100, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: AppColor.color2),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '아니요',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.color2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// "복사하기" API 호출 메서드
  Future<void> _copyCoverLetter(BuildContext context) async {
    // 1) userId 읽기
    final String? userId = await secureStorage.read(key: "user_id");
    if (userId == null) {
      print("❌ 저장된 user_id를 찾을 수 없습니다.");
      return;
    }

    // 2) 현재 resumeTitle과 일치하는 coverLetter 찾기
    final selectedCoverLetter = widget.coverLetters.firstWhere(
      (coverLetter) => coverLetter['title'] == widget.resumeTitle,
      orElse: () => null,
    );
    if (selectedCoverLetter == null) {
      print("❌ 해당 자기소개서를 찾을 수 없습니다. (resumeTitle=${widget.resumeTitle})");
      print("coverLetters 전체: ${widget.coverLetters}");
      return;
    }

    // 3) coverLetterId 추출
    final coverLetterId = selectedCoverLetter['coverLetterId'];
    if (coverLetterId == null) {
      print("❌ coverLetterId가 없습니다. selectedCoverLetter: $selectedCoverLetter");
      return;
    }

    // 4) API_BASE_URL 가져오기
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("❌ API_BASE_URL 환경 변수가 설정되지 않았습니다.");
      return;
    }

    // 5) PUT 요청 보내기
    final url =
        Uri.parse("$baseUrl/api/v1/coverLetter/copy/$userId/$coverLetterId");
    print("복사 API 호출 URL: $url");

    try {
      final response = await http.put(url);
      // --- UTF-8 디코딩 추가 ---
      final decodedBody = utf8.decode(response.bodyBytes);

      print("복사 API 응답 statusCode: ${response.statusCode}");
      print("복사 API 응답 body(디코딩 후): $decodedBody");

      if (response.statusCode == 200) {
        print("✅ 복사 성공! 응답 본문: $decodedBody");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('복사되었습니다.'),
            duration: Duration(seconds: 1),
          ),
        );
        // TODO: 복사 후 필요한 추가 작업(목록 갱신 등)이 있다면 여기에 로직 추가
      } else {
        print("❌ 복사 실패! 상태 코드: ${response.statusCode}, 응답 본문: $decodedBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('복사 실패: $decodedBody'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("❌ 네트워크 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('네트워크 오류: $e'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) async {
        if (value == 'preview') {
          // "미리보기" 선택 시 GET API 호출 → 다이얼로그 표시
          await _showPreviewDialog(context);
        } else if (value == 'delete') {
          _showDeleteDialog(context);
        } else if (value == 'modify') {
          // 만약 외부에서 콜백을 전달했다면 실행
          if (widget.onModifyPressed != null) {
            widget.onModifyPressed!();
          } else {
            // 기본 수정 동작: resumeTitle에 해당하는 coverLetter 찾기
            final selectedCoverLetter = widget.coverLetters.firstWhere(
              (coverLetter) => coverLetter['title'] == widget.resumeTitle,
              orElse: () => null,
            );

            if (selectedCoverLetter != null) {
              List<dynamic> questions =
                  selectedCoverLetter['questionAnswers'] ?? [];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CoverLetterEdit(
                    resumeTitle: widget.resumeTitle,
                    questions: questions,
                  ),
                ),
              );
            }
          }
        } else if (value == 'copy') {
          // "복사하기" 선택 시 복사 API 호출
          await _copyCoverLetter(context);
        } else {
          print('Selected: $value for ${widget.resumeTitle}');
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: 'preview',
            child: Center(
              child: Text(
                '미리보기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const PopupMenuItem(
            value: 'modify',
            child: Center(
              child: Text(
                '수정하기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Center(
              child: Text(
                '삭제하기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const PopupMenuItem(
            value: 'copy',
            child: Center(
              child: Text(
                '복사하기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ];
      },
    );
  }
}
