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

  /// 자소서 미리보기
  Future<void> _showPreviewDialog(BuildContext context) async {
    final String? userId = await secureStorage.read(key: "user_id");
    if (userId == null) {
      print("❌ 저장된 user_id를 찾을 수 없습니다.");
      return;
    }

    final selectedCoverLetter = widget.coverLetters.firstWhere(
      (coverLetter) => coverLetter['title'] == widget.resumeTitle,
      orElse: () => null,
    );
    if (selectedCoverLetter == null) {
      print("❌ 해당 자기소개서를 찾을 수 없습니다. (resumeTitle=${widget.resumeTitle})");
      return;
    }

    final coverLetterId = selectedCoverLetter['coverLetterId'];
    if (coverLetterId == null) {
      print("❌ coverLetterId가 없습니다. selectedCoverLetter: $selectedCoverLetter");
      return;
    }

    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("❌ API_BASE_URL 환경 변수가 설정되지 않았습니다.");
      return;
    }

    final url =
        Uri.parse("$baseUrl/api/v1/coverLetters/$userId/$coverLetterId");
    print("미리보기 API 호출 URL: $url");

    Map<String, dynamic>? previewData;
    try {
      final response = await http.get(url);
      print("미리보기 API 응답 statusCode: ${response.statusCode}");

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
      return;
    }

    if (previewData == null) {
      print("❌ previewData가 null입니다.");
      return;
    }

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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 자소서 삭제하기 (실제 API 호출)
  Future<void> _deleteCoverLetter(BuildContext context) async {
    final String? userId = await secureStorage.read(key: "user_id");
    if (userId == null) {
      print("❌ 저장된 user_id를 찾을 수 없습니다.");
      return;
    }

    final selectedCoverLetter = widget.coverLetters.firstWhere(
      (coverLetter) => coverLetter['title'] == widget.resumeTitle,
      orElse: () => null,
    );
    if (selectedCoverLetter == null) {
      print("❌ 해당 자기소개서를 찾을 수 없습니다. (resumeTitle=${widget.resumeTitle})");
      return;
    }

    final coverLetterId = selectedCoverLetter['coverLetterId'];
    if (coverLetterId == null) {
      print("❌ coverLetterId가 없습니다. selectedCoverLetter: $selectedCoverLetter");
      return;
    }

    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("❌ API_BASE_URL 환경 변수가 설정되지 않았습니다.");
      return;
    }

    final url =
        Uri.parse("$baseUrl/api/v1/coverLetters/$userId/$coverLetterId");
    print("삭제 API 호출 URL: $url");

    try {
      final response = await http.delete(url);
      final decodedBody = utf8.decode(response.bodyBytes);

      print("삭제 API 응답 statusCode: ${response.statusCode}");
      print("삭제 API 응답 body(디코딩 후): $decodedBody");

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("✅ 삭제 성공! 응답 본문: $decodedBody");
        // UI 갱신, SnackBar 표시 등 필요한 로직 수행
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('삭제되었습니다.'),
            duration: Duration(seconds: 1),
          ),
        );
        Navigator.of(context).pop(); // 다이얼로그 닫기
      } else {
        print("❌ 삭제 실패! 상태 코드: ${response.statusCode}, 응답 본문: $decodedBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('삭제 실패: $decodedBody'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("❌ 네트워크 오류(삭제): $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('네트워크 오류: $e'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
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
                      onPressed: () async {
                        // "예" 버튼 누르면 삭제 API 호출
                        await _deleteCoverLetter(context);
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
                        Navigator.of(context).pop(); // 다이얼로그 닫기
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

  /// "복사하기" API 호출
  Future<void> _copyCoverLetter(BuildContext context) async {
    final String? userId = await secureStorage.read(key: "user_id");
    if (userId == null) {
      print("❌ 저장된 user_id를 찾을 수 없습니다.");
      return;
    }

    final selectedCoverLetter = widget.coverLetters.firstWhere(
      (coverLetter) => coverLetter['title'] == widget.resumeTitle,
      orElse: () => null,
    );
    if (selectedCoverLetter == null) {
      print("❌ 해당 자기소개서를 찾을 수 없습니다. (resumeTitle=${widget.resumeTitle})");
      return;
    }

    final coverLetterId = selectedCoverLetter['coverLetterId'];
    if (coverLetterId == null) {
      print("❌ coverLetterId가 없습니다. selectedCoverLetter: $selectedCoverLetter");
      return;
    }

    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("❌ API_BASE_URL 환경 변수가 설정되지 않았습니다.");
      return;
    }

    final url =
        Uri.parse("$baseUrl/api/v1/coverLetters/copy/$userId/$coverLetterId");
    print("복사 API 호출 URL: $url");

    try {
      final response = await http.put(url);
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
        // 복사 후 필요한 추가 작업(목록 갱신 등)이 있다면 여기에 로직 추가
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
      print("❌ 네트워크 오류(복사): $e");
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
          // "미리보기"
          await _showPreviewDialog(context);
        } else if (value == 'delete') {
          // "삭제하기"
          _showDeleteDialog(context);
        } else if (value == 'modify') {
          // "수정하기"
          if (widget.onModifyPressed != null) {
            widget.onModifyPressed!();
          } else {
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
          // "복사하기"
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
          // const PopupMenuItem(
          //   value: 'copy',
          //   child: Center(
          //     child: Text(
          //       '복사하기',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         color: Colors.black,
          //         fontWeight: FontWeight.normal,
          //         fontSize: 12,
          //       ),
          //     ),
          //   ),
          // ),
        ];
      },
    );
  }
}
