import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/screens/coverletter_edit.dart';
import 'package:frontend/screens/theme/app_colors.dart';
import 'package:frontend/utils/http_interceptor.dart';

class IntroductionListPopupMenuBtn extends StatefulWidget {
  final String resumeTitle;             // 카드 제목
  final List<dynamic> coverLetters;     // 홈화면에서 전달받은 전체 자소서 원본
  final VoidCallback? onModifyPressed;  // 수정 콜백(Optional)
  final VoidCallback? onDeleteSuccess;

  const IntroductionListPopupMenuBtn({
    Key? key,
    required this.resumeTitle,
    required this.coverLetters,
    this.onModifyPressed,
    this.onDeleteSuccess,
  }) : super(key: key);

  @override
  State<IntroductionListPopupMenuBtn> createState() =>
      _IntroductionListPopupMenuBtnState();
}

class _IntroductionListPopupMenuBtnState
    extends State<IntroductionListPopupMenuBtn> {
  final HttpInterceptor interceptor = HttpInterceptor();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // coverLetterId 찾아오기
  int? _findCoverLetterId() {
    final selected = widget.coverLetters.firstWhere(
          (c) => c['title'] == widget.resumeTitle,
      orElse: () => null,
    );
    return selected?['coverLetterId'] as int?;
  }

  // v2 스펙에 맞춘 URI 헬퍼
  Future<Uri> _makeUri(int id, {String endpoint = ''}) async {
    final base = dotenv.env['API_BASE_URL'];
    if (base == null) throw Exception('API_BASE_URL not set');
    // endpoint: '' or '/copy'
    return Uri.parse('$base/api/v1/coverLetters$endpoint/$id');
  }

  // 미리보기(GET /api/v1/coverLetters/{id})
  Future<void> _showPreviewDialog(BuildContext context) async {
    final id = _findCoverLetterId();
    if (id == null) return;

    try {
      final uri = await _makeUri(id);
      final res = await interceptor.get(uri);
      final body = utf8.decode(res.bodyBytes);

      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('미리보기 실패: $body')));
        return;
      }
      final data = jsonDecode(body) as Map<String, dynamic>;
      final qas = data['questionAnswers'] as List<dynamic>;

      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: 353,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['title'] ?? '제목 없음',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  ...qas.map<Widget>((qa) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Q. ${qa['question']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('A. ${qa['answer']}',
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
    } catch (e) {
      print('Preview error: $e');
    }
  }

  // 삭제(DELETE /api/v1/coverLetters/{id})
  Future<void> _deleteCoverLetter() async {
    final id = _findCoverLetterId();
    if (id == null) return;

    try {
      final uri = await _makeUri(id);
      final res = await interceptor.delete(uri);
      final body = utf8.decode(res.bodyBytes);

      if (res.statusCode == 200 || res.statusCode == 204) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('삭제되었습니다.')));
        Navigator.pop(context); // 다이얼로그 닫기
        // widget.onDeleteSuccess?.call();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('삭제 실패: $body')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('네트워크 오류: $e')));
    }
  }

  // 복사(PUT /api/v1/coverLetters/copy/{id})
  Future<void> _copyCoverLetter() async {
    final id = _findCoverLetterId();
    if (id == null) return;

    try {
      final uri = await _makeUri(id, endpoint: '/copy');
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
            await _deleteCoverLetter();
            // showDialog(
            //   context: context,
            //   builder: (dialogContext) => AlertDialog(
            //     title: Text(widget.resumeTitle),
            //     content: const Text('정말 삭제하시겠습니까?'),
            //     actions: [
            //       TextButton(
            //         onPressed: () {
            //           Navigator.of(dialogContext).pop();
            //           _deleteCoverLetter();
            //         },
            //         child: const Text('예'),
            //       ),
            //       TextButton(
            //         onPressed: () => Navigator.of(dialogContext).pop(),
            //         child: const Text('아니요'),
            //       ),
            //     ],
            //   ),
            // );
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
