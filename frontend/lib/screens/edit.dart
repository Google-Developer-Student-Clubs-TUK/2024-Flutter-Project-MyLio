import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/resume/award_page.dart';
import 'package:frontend/screens/resume/capability_page.dart';
import 'package:frontend/screens/resume/certificate_page.dart';
import 'package:frontend/screens/resume/language_page.dart';
import 'package:frontend/screens/resume/strength_page.dart';
import 'package:frontend/screens/resume/weakness_page.dart';
import 'package:frontend/utils/http_interceptor.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'resume/resume_title.dart';
import 'resume/industrial_group.dart';
import 'resume/job_duty.dart';
import 'resume/activity_experience.dart';

class Edit extends StatefulWidget {
  final Map<String, dynamic> resumeData;

  const Edit({super.key, required this.resumeData});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late Map<String, dynamic> resumeData;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    resumeData = widget.resumeData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Colors.white,
      body: _buildBody(),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  /* ─────────────────────────── UI 섹션 ─────────────────────────── */
  AppBar _buildAppBar(BuildContext ctx) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('이력서 수정',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(ctx),
        ),
      );

  Widget _buildBody() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tapField('이력서 제목 *', resumeData['title'] ?? '', () async {
              final v = await Get.to(() => Resume_Title(
                    initialTitle: resumeData['title'] ?? '',
                    title: resumeData['title'] ?? '',
                  ));
              if (v is String) setState(() => resumeData['title'] = v);
            }),
            const SizedBox(height: 16),
            _tapField('산업군 *', resumeData['industries']?.join(', ') ?? '',
                () async {
              final v = await Get.to(() => Industrial_Group(
                    initialIndustries:
                        List<String>.from(resumeData['industries'] ?? []),
                  ));
              if (v is List<String>) {
                setState(() => resumeData['industries'] = v);
              }
            }),
            const SizedBox(height: 16),
            _tapField('직무 *', resumeData['jobDuty'] ?? '', () async {
              final v = await Get.to(
                  () => Job_Duty(initialJobDuty: resumeData['jobDuty'] ?? ''));
              if (v is String) setState(() => resumeData['jobDuty'] = v);
            }),
            const SizedBox(height: 16),
            _tapField(
              '활동/경험',
              resumeData['activityExperience']
                      ?.map((a) => a['name'])
                      .join(', ') ??
                  '',
              () async {
                final v = await Get.to(() => ActivityExperience(
                      initialActivities: List<Map<String, String>>.from(
                          (resumeData['activityExperience'] ?? [])
                              .map<Map<String, String>>((act) => (act as Map)
                                  .map((k, val) => MapEntry(
                                      k.toString(), val?.toString() ?? '')))),
                    ));
                if (v is List<Map<String, dynamic>>) {
                  setState(() => resumeData['activityExperience'] = v);
                }
              },
            ),
            const SizedBox(height: 16),
            _tapField('역량', resumeData['capabilities']?.join(', ') ?? '',
                () async {
              final v = await Get.to(() => CapabilityPage(
                    initialCapabilities:
                        List<String>.from(resumeData['capabilities'] ?? []),
                  ));
              if (v is List<String>) {
                setState(() => resumeData['capabilities'] = v);
              }
            }),
            const SizedBox(height: 16),
            _tapField(
              '수상경력',
              resumeData['awards']?.map((a) => a['name']).join(', ') ?? '',
              () async {
                final v = await Get.to(() => AwardPage(
                      initialAwards: List<Map<String, String>>.from(
                          (resumeData['awards'] ?? []).map<Map<String, String>>(
                              (aw) => (aw as Map).map((k, val) => MapEntry(
                                  k.toString(), val?.toString() ?? '')))),
                    ));
                if (v is List<Map<String, dynamic>>) {
                  setState(() => resumeData['awards'] = v);
                }
              },
            ),
            const SizedBox(height: 16),
            _tapField('강점', resumeData['strengths']?.join(', ') ?? '',
                () async {
              final v = await Get.to(() => StrengthPage(
                    initialStrengths:
                        List<String>.from(resumeData['strengths'] ?? []),
                  ));
              if (v is List<String>) {
                setState(() => resumeData['strengths'] = v);
              }
            }),
            const SizedBox(height: 16),
            _tapField('약점', resumeData['weaknesses']?.join(', ') ?? '',
                () async {
              final v = await Get.to(() => WeaknessPage(
                    initialWeaknesses:
                        List<String>.from(resumeData['weaknesses'] ?? []),
                  ));
              if (v is List<String>) {
                setState(() => resumeData['weaknesses'] = v);
              }
            }),
            const SizedBox(height: 16),
            _tapField(
              '자격증',
              resumeData['certificates']?.map((c) => c['name']).join(', ') ??
                  '등록된 자격증 없음',
              () async {
                final v = await Get.to(() => CertificatePage(
                      initialCertificates: List<Map<String, String>>.from(
                          (resumeData['certificates'] ?? [])
                              .map<Map<String, String>>((cert) => (cert as Map)
                                  .map((k, val) => MapEntry(
                                      k.toString(), val?.toString() ?? '')))),
                    ));
                if (v is List<Map<String, dynamic>>) {
                  setState(() => resumeData['certificates'] = v);
                }
              },
            ),
            const SizedBox(height: 16),
            _tapField(
              '어학',
              resumeData['languages']?.map((l) => l['language']).join(', ') ??
                  '등록된 어학 정보 없음',
              () async {
                final v = await Get.to(() => LanguagePage(
                      initialLanguages: List<Map<String, String>>.from(
                          (resumeData['languages'] ?? [])
                              .map<Map<String, String>>((lang) => (lang as Map)
                                  .map((k, val) => MapEntry(
                                      k.toString(), val?.toString() ?? '')))),
                    ));
                if (v is List<Map<String, dynamic>>) {
                  setState(() => resumeData['languages'] = v);
                }
              },
            ),
          ],
        ),
      );

  Widget _tapField(String label, String value, VoidCallback onTap) =>
      GestureDetector(onTap: onTap, child: _buildInputField(label, value));

  Widget _buildInputField(String label, String value) => Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text('$label: $value',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    overflow: TextOverflow.ellipsis)),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      );

  /* ───────────────────── 하단 저장 버튼 ───────────────────── */
  Widget _buildSaveButton() => Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _saveResume,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF908CFF),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('저장하기',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      );

  /* ───────────────────── 서버 저장 로직 ───────────────────── */
  Future<void> _saveResume() async {
    try {
      final resumeId = resumeData['resume_id']?.toString();
      if (resumeId == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('resumeId 가 없습니다.')));
        return;
      }

      final baseUrl = dotenv.env['API_BASE_URL'];
      if (baseUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('API_BASE_URL이 설정되지 않았습니다.')));
        return;
      }

      /* ⭐ accessToken 쿼리 파라미터 추가 */
      final token = await secureStorage.read(key: 'jwt_token');
      if (token == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('로그인이 필요합니다.')));
        return;
      }

      final url = Uri.parse(
          '$baseUrl/api/v1/resume/update/$resumeId?accessToken=$token');
      print('📤 이력서 수정 요청 URL: $url');

      /* 서버가 요구하는 필드명으로 변환 */
      final body = {
        "resumeTitle": resumeData['title'] ?? '',
        "industryGroups": List<String>.from(resumeData['industries'] ?? []),
        "jobDuty": resumeData['jobDuty'] ?? '',
        "activityExperience": List<Map<String, dynamic>>.from(
            resumeData['activityExperience'] ?? []),
        "awards": List<Map<String, dynamic>>.from(resumeData['awards'] ?? []),
        "certificates":
            List<Map<String, dynamic>>.from(resumeData['certificates'] ?? []),
        "languages":
            List<Map<String, dynamic>>.from(resumeData['languages'] ?? []),
        "strengths": List<String>.from(resumeData['strengths'] ?? []),
        "weaknesses": List<String>.from(resumeData['weaknesses'] ?? []),
        "capabilities": List<String>.from(resumeData['capabilities'] ?? []),
      };
      print('📤 전송 데이터: $body');

      final res = await HttpInterceptor().put(url, body: jsonEncode(body));

      print('📨 Status: ${res.statusCode}\n📨 Body: ${res.body}');

      if (res.statusCode == 200) {
        Navigator.pop(context, resumeData); // 수정된 데이터 반환
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('수정 실패 (${res.statusCode})')));
      }
    } catch (e) {
      print('❌ 수정 오류: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('네트워크 오류가 발생했습니다.')));
    }
  }
}
