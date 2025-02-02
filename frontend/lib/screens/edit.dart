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
import 'resume/resume_title.dart';
import 'resume/industrial_group.dart';
import 'resume/job_duty.dart';
import 'resume/activity_experience.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Edit extends StatefulWidget {
  final Map<String, dynamic> resumeData;

  const Edit({Key? key, required this.resumeData}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late Map<String, dynamic> resumeData;

  @override
  void initState() {
    super.initState();
    resumeData = widget.resumeData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            '이력서 수정',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: _buildInputField('이력서 제목 *', resumeData['title'] ?? ''),
                onTap: () async {
                  final updatedTitle = await Get.to(() => Resume_Title(
                        initialTitle: resumeData['title'] ?? '',
                        title: resumeData['title'] ?? '', // 추가
                      ));

                  if (updatedTitle != null && updatedTitle is String) {
                    setState(() {
                      resumeData['title'] = updatedTitle;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                child: _buildInputField(
                    '산업군 *', resumeData['industries']?.join(', ') ?? ''),
                onTap: () async {
                  final updatedIndustries = await Get.to(() => Industrial_Group(
                        initialIndustries:
                            List<String>.from(resumeData['industries'] ?? []),
                      ));

                  if (updatedIndustries != null &&
                      updatedIndustries is List<String>) {
                    setState(() {
                      resumeData['industries'] = updatedIndustries;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                child: _buildInputField('직무 *', resumeData['jobDuty'] ?? ''),
                onTap: () async {
                  final updatedJobDuty = await Get.to(() => Job_Duty(
                        initialJobDuty: resumeData['jobDuty'] ?? '',
                      ));

                  if (updatedJobDuty != null && updatedJobDuty is String) {
                    setState(() {
                      resumeData['jobDuty'] = updatedJobDuty;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                child: _buildInputField(
                  '활동/경험',
                  resumeData['activityExperience']
                          ?.map((activity) => activity['name'])
                          .join(', ') ??
                      '',
                ),
                onTap: () async {
                  final updatedActivities =
                      await Get.to(() => ActivityExperience(
                            initialActivities:
                                resumeData['activityExperience'] != null
                                    ? List<Map<String, String>>.from(
                                        (resumeData['activityExperience']
                                                as List)
                                            .map(
                                          (activity) => (activity as Map)
                                              .map((key, value) => MapEntry(
                                                    key.toString(),
                                                    value != null
                                                        ? value.toString()
                                                        : '',
                                                  )),
                                        ),
                                      )
                                    : [],
                          ));

                  if (updatedActivities != null &&
                      updatedActivities is List<Map<String, dynamic>>) {
                    setState(() {
                      resumeData['activityExperience'] = updatedActivities;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final updatedCapabilities = await Get.to(() => CapabilityPage(
                        initialCapabilities:
                            List<String>.from(resumeData['capabilities'] ?? []),
                      ));

                  if (updatedCapabilities != null &&
                      updatedCapabilities is List<String>) {
                    setState(() {
                      resumeData['capabilities'] = updatedCapabilities;
                    });
                  }
                },
                child: _buildInputField(
                    '역량', resumeData['capabilities']?.join(', ') ?? ''),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final updatedAwards = await Get.to(() => AwardPage(
                        initialAwards: resumeData['awards'] != null
                            ? List<Map<String, String>>.from(
                                (resumeData['awards'] as List).map(
                                  (award) =>
                                      (award as Map<String, dynamic>).map(
                                    (key, value) => MapEntry(
                                      key.toString(),
                                      value != null ? value.toString() : '',
                                    ),
                                  ),
                                ),
                              )
                            : [],
                      ));

                  if (updatedAwards != null &&
                      updatedAwards is List<Map<String, dynamic>>) {
                    setState(() {
                      resumeData['awards'] = updatedAwards;
                    });
                  }
                },
                child: _buildInputField(
                  '수상경력',
                  resumeData['awards']
                          ?.map((award) => award['name'])
                          .join(', ') ??
                      '',
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final updatedStrengths = await Get.to(() => StrengthPage(
                        initialStrengths:
                            List<String>.from(resumeData['strengths'] ?? []),
                      ));

                  if (updatedStrengths != null &&
                      updatedStrengths is List<String>) {
                    setState(() {
                      resumeData['strengths'] = updatedStrengths;
                    });
                  }
                },
                child: _buildInputField(
                    '강점', resumeData['strengths']?.join(', ') ?? ''),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final updatedWeaknesses = await Get.to(() => WeaknessPage(
                        initialWeaknesses:
                            List<String>.from(resumeData['weaknesses'] ?? []),
                      ));

                  if (updatedWeaknesses != null &&
                      updatedWeaknesses is List<String>) {
                    setState(() {
                      resumeData['weaknesses'] = updatedWeaknesses;
                    });
                  }
                },
                child: _buildInputField(
                    '약점', resumeData['weaknesses']?.join(', ') ?? ''),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final updatedCertificates = await Get.to(() =>
                      CertificatePage(
                        initialCertificates: resumeData['certificates'] != null
                            ? List<Map<String, String>>.from(
                                (resumeData['certificates'] as List).map(
                                  (certificate) =>
                                      (certificate as Map<String, dynamic>).map(
                                    (key, value) => MapEntry(
                                      key.toString(),
                                      value != null ? value.toString() : '',
                                    ),
                                  ),
                                ),
                              )
                            : [],
                      ));

                  if (updatedCertificates != null &&
                      updatedCertificates is List<Map<String, dynamic>>) {
                    setState(() {
                      resumeData['certificates'] = updatedCertificates;
                    });
                  }
                },
                child: _buildInputField(
                  '자격증',
                  resumeData['certificates'] != null &&
                          resumeData['certificates'].isNotEmpty
                      ? resumeData['certificates']
                          .map((certificate) => certificate['name'])
                          .join(', ')
                      : '등록된 자격증 없음',
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final updatedLanguages = await Get.to(() => LanguagePage(
                        initialLanguages: resumeData['languages'] != null
                            ? List<Map<String, String>>.from(
                                (resumeData['languages'] as List).map(
                                  (language) =>
                                      (language as Map<String, dynamic>).map(
                                    (key, value) => MapEntry(
                                      key.toString(),
                                      value != null ? value.toString() : '',
                                    ),
                                  ),
                                ),
                              )
                            : [],
                      ));

                  if (updatedLanguages != null &&
                      updatedLanguages is List<Map<String, dynamic>>) {
                    setState(() {
                      resumeData['languages'] = updatedLanguages;
                    });
                  }
                },
                child: _buildInputField(
                  '어학',
                  resumeData['languages'] != null &&
                          resumeData['languages'].isNotEmpty
                      ? resumeData['languages']
                          .map((language) => language['language'])
                          .join(', ')
                      : '등록된 어학 정보 없음',
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () async {
              try {
                print("🔍 수정 전 resumeData: $resumeData");

                const userId = '1';
                final resumeId = resumeData['resume_id']?.toString();

                final baseUrl = dotenv.env['API_BASE_URL'];
                final url = Uri.parse(
                    '$baseUrl/api/v1/resume/update/$userId/$resumeId');

                print('📤 이력서 수정 요청 URL: $url');

                // ✅ 서버가 요구하는 JSON 형식으로 변환
                final updatedResumeData = {
                  "resumeTitle": resumeData['title'] ?? '',
                  "industryGroups":
                      List<String>.from(resumeData['industries'] ?? []),
                  "jobDuty": resumeData['jobDuty'] ?? '',
                  "activityExperience": List<Map<String, dynamic>>.from(
                      resumeData['activityExperience'] ?? []),
                  "awards": List<Map<String, dynamic>>.from(
                      resumeData['awards'] ?? []),
                  "certificates": List<Map<String, dynamic>>.from(
                      resumeData['certificates'] ?? []),
                  "languages": List<Map<String, dynamic>>.from(
                      resumeData['languages'] ?? []),
                  "strengths": List<String>.from(resumeData['strengths'] ?? []),
                  "weaknesses":
                      List<String>.from(resumeData['weaknesses'] ?? []),
                  "capabilities":
                      List<String>.from(resumeData['capabilities'] ?? []),
                };

                print("📤 서버로 전송할 데이터: $updatedResumeData");

                final response = await HttpInterceptor().put(
                  url,
                  body: jsonEncode(updatedResumeData),
                );

                print('📨 Response Status Code: ${response.statusCode}');
                print('📨 Response Body: ${response.body}');

                if (response.statusCode == 200) {
                  print('✅ 이력서 수정 성공');
                  Navigator.pop(context, updatedResumeData); // 🎯 수정된 데이터만 반환
                } else {
                  print('❌ 이력서 수정 실패: ${response.statusCode}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '이력서 수정 실패 (${response.statusCode}). 다시 시도해주세요.')),
                  );
                }
              } catch (e) {
                print('❌ 이력서 수정 중 오류 발생: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('네트워크 오류가 발생했습니다. 인터넷 연결을 확인하세요.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF908CFF),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '저장하기',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }

  Widget _buildInputField(String label, String value) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
