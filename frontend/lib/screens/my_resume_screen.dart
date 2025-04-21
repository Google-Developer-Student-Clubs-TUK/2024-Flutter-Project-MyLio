// my_resume_screen.dart
// * /resume/* Swagger 경로에 맞춰 userId 파라미터 제거 & accessToken 쿼리 전송
// * MyResumeEmptyWidget 콜백 시그니처 래핑(Error fix)
// * 복사 시 중복 제목 뒤에 (1)(2)… 자동 부여

import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/screens/edit.dart';
import 'package:frontend/screens/my_resume_create_page.dart';
import 'package:frontend/utils/http_interceptor.dart';
import 'package:get/get.dart';

import 'components/resume_PopupMenu_Btn.dart';
import 'theme/app_colors.dart';
import 'widgets/my_resume_empty_widget.dart';

class MyResumeScreen extends StatefulWidget {
  const MyResumeScreen({super.key, required this.resumeTitle});
  final String resumeTitle;

  @override
  State<MyResumeScreen> createState() => _MyResumeScreenState();
}

class _MyResumeScreenState extends State<MyResumeScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final HttpInterceptor interceptor = HttpInterceptor();

  List<Map<String, dynamic>> resumes = [];

  /* ------------------------------------------------------------------ */
  /*                         공통 URI 헬퍼                                */
  /* ------------------------------------------------------------------ */
  Future<Uri?> _uri(String path) async {
    final base = dotenv.env['API_BASE_URL'];
    if (base == null) {
      print('❌ API_BASE_URL 없음');
      return null;
    }
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      print('❌ ACCESS_TOKEN 없음');
      return null;
    }
    return Uri.parse('$base$path?accessToken=$token');
  }

  /* ------------------------------------------------------------------ */
  /*                       전체 목록 GET (/my)                           */
  /* ------------------------------------------------------------------ */
  Future<void> _fetchResumes() async {
    final u = await _uri('/api/v1/resume/my');
    if (u == null) return;

    try {
      final res = await interceptor.get(u);
      if (res.statusCode == 200) {
        final decoded = utf8.decode(res.bodyBytes);
        final List data = jsonDecode(decoded);

        setState(() {
          resumes = data
              .map((e) => {
                    'resume_id': e['resumeId'] ?? '',
                    'title': e['resumeTitle'] ?? 'Untitled',
                    'isPrimary': e['isPrimary'] ?? false,
                    'industries': List<String>.from(e['industryGroups'] ?? []),
                    'jobDuty': e['jobDuty'] ?? '',
                    'capabilities': List<String>.from(e['capabilities'] ?? []),
                    'strengths': List<String>.from(e['strengths'] ?? []),
                    'weaknesses': List<String>.from(e['weaknesses'] ?? []),
                    'activityExperience': List<Map<String, dynamic>>.from(
                        e['activityExperience'] ?? []),
                    'awards':
                        List<Map<String, dynamic>>.from(e['awards'] ?? []),
                    'certificates': List<Map<String, dynamic>>.from(
                        e['certificates'] ?? []),
                    'languages':
                        List<Map<String, dynamic>>.from(e['languages'] ?? []),
                  })
              .toList();
        });
      } else {
        print('⚠️ 목록 실패: ${res.statusCode}');
      }
    } catch (e) {
      print('⚠️ 목록 오류: $e');
    }
  }

  /* ------------------------------------------------------------------ */
  /*                       이력서 삭제 (DELETE)                          */
  /* ------------------------------------------------------------------ */
  Future<void> _deleteResume(String id) async {
    final u = await _uri('/api/v1/resume/delete/$id');
    if (u == null) return;
    final res = await interceptor.delete(u);
    if (res.statusCode == 200 || res.statusCode == 204) _fetchResumes();
  }

  /* ------------------------------------------------------------------ */
  /*                대표 설정 (POST /set‑primary/{id})                   */
  /* ------------------------------------------------------------------ */
  Future<void> _setPrimary(String id) async {
    final u = await _uri('/api/v1/resume/set-primary/$id');
    if (u == null) return;
    final res = await interceptor.post(u);
    if (res.statusCode == 200) _fetchResumes();
  }

  /* ------------------------------------------------------------------ */
  /*                복제 (PUT /copy/{id}) + 제목 (1)(2)                  */
  /* ------------------------------------------------------------------ */
  String _dupTitle(String base) {
    final titles = resumes.map((r) => r['title'] as String).toList();
    if (!titles.contains(base)) return '$base (1)';
    final rg = RegExp(r'\((\d+)\)$');
    int mx = 1;
    for (final t in titles.where((t) => t.startsWith(base))) {
      final m = rg.firstMatch(t);
      if (m != null) {
        final n = int.parse(m.group(1)!);
        if (n >= mx) mx = n + 1;
      }
    }
    return '$base ($mx)';
  }

  Future<void> _duplicate(String id) async {
    final u = await _uri('/api/v1/resume/copy/$id');
    if (u == null) return;

    final origin = resumes.firstWhere((r) => r['resume_id'].toString() == id);
    final newTitle = _dupTitle(origin['title']);

    final res = await interceptor.put(u, body: jsonEncode({'title': newTitle}));
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('복사 완료: $newTitle')));
      _fetchResumes();
    } else {
      print('⚠️ 복사 실패: ${res.body}');
    }
  }

  /* ------------------------------------------------------------------ */
  /*                        초기 로드                                    */
  /* ------------------------------------------------------------------ */
  @override
  void initState() {
    super.initState();
    _fetchResumes();
  }

  /* ------------------------------------------------------------------ */
  /*                               UI                                   */
  /* ------------------------------------------------------------------ */
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () => Navigator.pop(context)),
          title: const Text('My 이력서',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.white,
        body: resumes.isEmpty
            // --------------------------- 콜백 래핑 ---------------------------
            ? MyResumeEmptyWidget(
                onResumeAdded: (
                  String title,
                  List<String> industries,
                  String jobDuty,
                  List<String> capabilities,
                  List<String> strengths,
                  List<String> weaknesses,
                  List<Map<String, String>> act,
                  List<Map<String, String>> awards,
                  List<Map<String, String>> certs,
                  List<Map<String, String>> langs,
                ) {
                  setState(() {
                    resumes.add({
                      'resume_id': DateTime.now().toIso8601String(),
                      'title': title,
                      'industries': industries,
                      'jobDuty': jobDuty,
                      'capabilities': capabilities,
                      'strengths': strengths,
                      'weaknesses': weaknesses,
                      'activityExperience': act,
                      'awards': awards,
                      'certificates': certs,
                      'languages': langs,
                      'isPrimary': false,
                    });
                  });
                },
              )
            : _resumeList(),
      );

  /* --------------------------- 리스트 위젯 -------------------------- */
  Widget _resumeList() => Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: resumes.length,
                itemBuilder: (_, idx) {
                  final r = resumes[idx];
                  final isPrimary = r['isPrimary'] == true;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBFBFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 57,
                              height: 18,
                              decoration: BoxDecoration(
                                  color: isPrimary
                                      ? const Color(0xFF908CFF)
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(isPrimary ? '대표 이력서' : '이력서',
                                  style: TextStyle(
                                      color: isPrimary
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const Spacer(),
                            ResumePopupMenuBtn(
                              onSetRepresentative: () =>
                                  _setPrimary(r['resume_id'].toString()),
                              onEdit: () async {
                                final upd = await Get.to(() => Edit(
                                    resumeData: Map<String, dynamic>.from(r)));
                                if (upd != null) _fetchResumes();
                              },
                              onDelete: () =>
                                  _deleteResume(r['resume_id'].toString()),
                              onDuplicate: () =>
                                  _duplicate(r['resume_id'].toString()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('ID: ${r['resume_id']}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 5),
                        Text(r['title'],
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                        _info('산업군', r['industries']),
                        _info('직무', r['jobDuty']),
                        _info('역량', r['capabilities']),
                        _info('강점', r['strengths']),
                        _info('약점', r['weaknesses']),
                        _map('활동/경험', r['activityExperience'], 'name'),
                        _map('수상경력', r['awards'], 'name'),
                        _map('자격증', r['certificates'], 'name'),
                        _map('어학', r['languages'], 'language'),
                      ],
                    ),
                  );
                },
              ),
            ),
            _addButton(),
          ],
        ),
      );

  /* ---------------------------- Info helpers --------------------------- */
  Widget _info(String label, dynamic v) {
    if (v == null || (v is String && v.isEmpty) || (v is List && v.isEmpty))
      return const SizedBox();
    final txt = v is List ? v.join(', ') : v.toString();
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text('$label: $txt',
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }

  Widget _map(String label, List list, String key) => list.isEmpty
      ? const SizedBox()
      : _info(label, list.map((e) => e[key]).join(', '));

  /* ------------------------------ + 버튼 ------------------------------ */
  Widget _addButton() => GestureDetector(
        onTap: () async {
          final res = await Navigator.push(
              context, MaterialPageRoute(builder: (_) => MyResumeCreatePage()));
          if (res is Map<String, dynamic>) {
            setState(() => resumes.add(res));
          }
        },
        child: DottedBorder(
          color: Colors.grey,
          strokeWidth: 1,
          dashPattern: const [2, 2],
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          child: Container(
            width: 352,
            height: 47,
            alignment: Alignment.center,
            child: const Text('+ 이력서 추가',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      );
}
