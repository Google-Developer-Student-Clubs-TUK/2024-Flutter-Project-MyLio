import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/screens/coverletter_edit.dart';
import 'package:frontend/screens/theme/app_colors.dart';
import 'package:frontend/utils/http_interceptor.dart';

class IntroductionListPopupMenuBtn extends StatefulWidget {
  final String resumeTitle; // 카드 제목
  final List<dynamic> coverLetters; // 홈화면에서 전달받은 전체 자소서 원본
  final VoidCallback? onModifyPressed;

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
  final HttpInterceptor interceptor = HttpInterceptor(); // ⭐

  /* ──────────────────────────────────────────────────────────────── */
  /*                       공통: URL 헬퍼 & 토큰                       */
  /* ──────────────────────────────────────────────────────────────── */
  Future<Map<String, dynamic>?> _buildUrl(int coverLetterId,
      {required String endpoint}) async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("❌ API_BASE_URL 환경 변수가 없습니다.");
      return null;
    }
    final String? accessToken = await secureStorage.read(key: "jwt_token");
    if (accessToken == null) {
      print("❌ ACCESS_TOKEN이 없습니다. 로그인 필요!");
      return null;
    }

    /* endpoint 예시
       - ''                       → /coverLetters/{id}
       - '/copy'                  → /coverLetters/copy/{id}
    */
    final path = endpoint.isEmpty
        ? "$baseUrl/api/v1/coverLetters/$coverLetterId"
        : "$baseUrl/api/v1/coverLetters$endpoint/$coverLetterId";

    return {
      'uri': Uri.parse("$path?accessToken=$accessToken"),
      'token': accessToken,
    };
  }

  int? _findCoverLetterId() {
    final selected = widget.coverLetters.firstWhere(
      (c) => c['title'] == widget.resumeTitle,
      orElse: () => null,
    );
    return selected?['coverLetterId'] as int?;
  }

  /* ──────────────────────────────────────────────────────────────── */
  /*                            미리보기 (GET)                        */
  /* ──────────────────────────────────────────────────────────────── */
  Future<void> _showPreviewDialog(BuildContext context) async {
    final id = _findCoverLetterId();
    if (id == null) return;

    final urlInfo = await _buildUrl(id, endpoint: '');
    if (urlInfo == null) return;
    final uri = urlInfo['uri'] as Uri;

    Map<String, dynamic>? previewData;
    try {
      final res = await interceptor.get(uri); // 헤더 자동 + 쿼리 포함된 uri
      final decodedBody = utf8.decode(res.bodyBytes);
      print("미리보기 status:${res.statusCode} body:$decodedBody");

      if (res.statusCode == 200) {
        previewData = jsonDecode(decodedBody) as Map<String, dynamic>;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('미리보기 실패: $decodedBody')),
        );
        return;
      }
    } catch (e) {
      print("❌ 미리보기 네트워크 오류: $e");
      return;
    }

    final qas = previewData?['questionAnswers'] ?? [];

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 353,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(previewData?['title'] ?? '제목 없음',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                ...qas.map<Widget>((qa) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Q. ${qa['question']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text("A. ${qa['answer']}",
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 16),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* ──────────────────────────────────────────────────────────────── */
  /*                        삭제 (DELETE)                             */
  /* ──────────────────────────────────────────────────────────────── */
  Future<void> _deleteCoverLetter() async {
    final id = _findCoverLetterId();
    if (id == null) return;

    final urlInfo = await _buildUrl(id, endpoint: '');
    if (urlInfo == null) return;
    final uri = urlInfo['uri'] as Uri;

    try {
      final res = await interceptor.delete(uri);
      final decoded = utf8.decode(res.bodyBytes);
      if (res.statusCode == 200 || res.statusCode == 204) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('삭제되었습니다.')));
        Navigator.pop(context); // 다이얼로그 닫기
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('삭제 실패: $decoded')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('네트워크 오류: $e')));
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 228,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.resumeTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 30),
              const Text('정말 삭제하시겠습니까?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _deleteCoverLetter,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.color2,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 44)),
                    child: const Text('예'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(100, 44),
                        side: BorderSide(color: AppColor.color2)),
                    child: const Text('아니요',
                        style: TextStyle(color: AppColor.color2)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /* ──────────────────────────────────────────────────────────────── */
  /*                        복사 (PUT /copy/{id})                     */
  /* ──────────────────────────────────────────────────────────────── */
  Future<void> _copyCoverLetter() async {
    final id = _findCoverLetterId();
    if (id == null) return;

    final urlInfo = await _buildUrl(id, endpoint: '/copy');
    if (urlInfo == null) return;
    final uri = urlInfo['uri'] as Uri;

    try {
      final res = await interceptor.put(uri);
      final body = utf8.decode(res.bodyBytes);
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('복사되었습니다.')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('복사 실패: $body')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('네트워크 오류: $e')));
    }
  }

  /* ──────────────────────────────────────────────────────────────── */
  /*                              UI                                  */
  /* ──────────────────────────────────────────────────────────────── */
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) async {
        switch (value) {
          case 'preview':
            await _showPreviewDialog(context);
            break;
          case 'delete':
            _showDeleteDialog();
            break;
          case 'modify':
            if (widget.onModifyPressed != null) {
              widget.onModifyPressed!();
            } else {
              final selected = widget.coverLetters.firstWhere(
                  (c) => c['title'] == widget.resumeTitle,
                  orElse: () => null);
              if (selected != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoverLetterEdit(
                      resumeTitle: widget.resumeTitle,
                      questions: selected['questionAnswers'] ?? [],
                    ),
                  ),
                );
              }
            }
            break;
          case 'copy':
            await _copyCoverLetter();
            break;
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'preview',
          child: Center(child: Text('미리보기', style: TextStyle(fontSize: 12))),
        ),
        const PopupMenuItem(
          value: 'modify',
          child: Center(child: Text('수정하기', style: TextStyle(fontSize: 12))),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Center(child: Text('삭제하기', style: TextStyle(fontSize: 12))),
        ),
        const PopupMenuItem(
          value: 'copy',
          child: Center(child: Text('복사하기', style: TextStyle(fontSize: 12))),
        ),
      ],
    );
  }
}
