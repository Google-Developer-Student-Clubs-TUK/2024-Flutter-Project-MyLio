import 'package:flutter/material.dart';
import 'package:frontend/screens/add_resume.dart';
import 'package:frontend/screens/resume/award_page.dart';
import 'package:frontend/screens/resume/capability_page.dart';
import 'package:frontend/screens/resume/certificate_page.dart';
import 'package:frontend/screens/resume/language_page.dart';
import 'package:frontend/screens/resume/strength_page.dart';
import 'package:frontend/screens/resume/weakness_page.dart';
import 'package:get/get.dart';
import 'resume/resume_title.dart';
import 'resume/industrial_group.dart';
import 'resume/job_duty.dart';
import 'resume/activity_experience.dart';

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
              onTap: () {
                Get.to(() => Resume_Title(
                      initialTitle: resumeData['title'] ?? '',
                      title: resumeData['title'] ?? '',
                    ));
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              child: _buildInputField(
                  '산업군 *', resumeData['industries']?.join(', ') ?? ''),
              onTap: () {
                Get.to(Industrial_Group(
                  initialIndustries:
                      List<String>.from(resumeData['industries'] ?? []),
                ));
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              child: _buildInputField('직무 *', resumeData['jobDuty'] ?? ''),
              onTap: () {
                Get.to(Job_Duty(
                  initialJobDuty: resumeData['jobDuty'] ?? '',
                ));
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              child: _buildInputField(
                  '활동/경험',
                  resumeData['activityExperience']
                          ?.map((activity) => activity['name'])
                          .join(', ') ??
                      ''),
              onTap: () {
                Get.to(() => ActivityExperience(
                      initialActivities:
                          resumeData['activityExperience'] != null
                              ? List<Map<String, String>>.from(
                                  (resumeData['activityExperience'] as List)
                                      .map((activity) => (activity as Map).map(
                                          (key, value) => MapEntry(
                                              key.toString(),
                                              value != null
                                                  ? value.toString()
                                                  : ''))))
                              : [],
                    ));
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CapabilityPage(
                      initialCapabilities:
                          List<String>.from(resumeData['capabilities'] ?? []),
                    ),
                  ),
                );
              },
              child: _buildInputField(
                  '역량', resumeData['capabilities']?.join(', ') ?? ''),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AwardPage(
                      initialAwards: resumeData['awards'] != null
                          ? List<Map<String, String>>.from(
                              (resumeData['awards'] as List).map((award) =>
                                  (award as Map).map((key, value) => MapEntry(
                                      key.toString(),
                                      value != null ? value.toString() : ''))))
                          : [],
                    ),
                  ),
                );
              },
              child: _buildInputField(
                  '수상경력',
                  resumeData['awards']
                          ?.map((award) => award['name'])
                          .join(', ') ??
                      ''),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StrengthPage(
                      initialStrengths:
                          List<String>.from(resumeData['strengths'] ?? []),
                    ),
                  ),
                );
              },
              child: _buildInputField(
                  '강점', resumeData['strengths']?.join(', ') ?? ''),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeaknessPage(
                      initialWeaknesses:
                          List<String>.from(resumeData['weaknesses'] ?? []),
                    ),
                  ),
                );
              },
              child: _buildInputField(
                  '약점', resumeData['weaknesses']?.join(', ') ?? ''),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CertificatePage(
                      initialCertificates: resumeData['certificates'] != null
                          ? List<Map<String, String>>.from(
                              (resumeData['certificates'] as List).map(
                                (certificate) =>
                                    (certificate as Map<String, dynamic>).map(
                                  (key, value) => MapEntry(
                                    key.toString(),
                                    value != null
                                        ? value.toString()
                                        : '', // null 방지
                                  ),
                                ),
                              ),
                            )
                          : [], // 데이터가 없을 경우 빈 리스트 전달
                    ),
                  ),
                );
              },
              child: _buildInputField(
                '자격증',
                resumeData['certificates'] != null &&
                        resumeData['certificates'].isNotEmpty
                    ? resumeData['certificates']
                        .map((certificate) => certificate['name'])
                        .join(', ')
                    : '등록된 자격증 없음', // 데이터가 없을 경우 기본 텍스트 표시
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LanguagePage(
                      initialLanguages: resumeData['languages'] != null
                          ? List<Map<String, String>>.from(
                              (resumeData['languages'] as List).map(
                                (language) =>
                                    (language as Map<String, dynamic>).map(
                                  (key, value) => MapEntry(
                                      key.toString(),
                                      value != null
                                          ? value.toString()
                                          : ''), // null 방지
                                ),
                              ),
                            )
                          : [], // 데이터가 없을 경우 빈 리스트 전달
                    ),
                  ),
                );
              },
              child: _buildInputField(
                '어학',
                resumeData['languages'] != null &&
                        resumeData['languages'].isNotEmpty
                    ? resumeData['languages']
                        .map((language) => language['language'])
                        .join(', ')
                    : '등록된 어학 정보 없음', // 데이터가 없을 경우 기본 텍스트 표시
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            print('이력서 수정 완료');
            Navigator.pop(context, resumeData); // 수정된 데이터 반환
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
      ),
    );
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
