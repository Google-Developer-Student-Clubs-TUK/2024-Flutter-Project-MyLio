import 'package:flutter/material.dart';
import 'resume/resume_title.dart';
import 'resume/industrial_group.dart';
import 'resume/job_duty.dart';
import 'resume/activity_experience.dart';
import 'resume/capability_page.dart';
import 'resume/strength_page.dart';
import 'resume/weakness_page.dart';
import 'resume/award_page.dart';
import 'resume/certificate_page.dart';
import 'resume/language_page.dart';

class MyResumeCreatePage extends StatefulWidget {
  const MyResumeCreatePage({Key? key}) : super(key: key);

  @override
  State<MyResumeCreatePage> createState() => _MyResumeCreatePageState();
}

class _MyResumeCreatePageState extends State<MyResumeCreatePage> {
  String resumeTitle = ""; // 이력서 제목 저장
  List<String> industryGroups = []; // 산업군 데이터 저장
  String jobDuty = ""; // 직무 저장
  List<Map<String, String>> activityExperience = []; // 활동/경험 데이터 저장
  List<String> capabilities = []; // 역량 데이터 저장
  List<String> strengths = []; // 강점 데이터 저장
  List<String> weaknesses = []; // 약점 데이터 저장
  List<Map<String, String>> awards = []; // 수상경력 데이터 저장
  List<Map<String, String>> certificates = []; // 자격증 데이터 저장
  List<Map<String, String>> languages = []; // 어학 데이터 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '이력서 정보 입력',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputFieldWithNavigation(
              label: '이력서 제목 *',
              value: resumeTitle.isEmpty ? "입력되지 않음" : resumeTitle,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Resume_Title(
                      initialTitle: resumeTitle,
                      title: '',
                    ),
                  ),
                );
                if (result != null && result is String) {
                  setState(() {
                    resumeTitle = result;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildInputFieldWithNavigation(
              label: '산업군 *',
              value: industryGroups.isEmpty
                  ? "선택하지 않음"
                  : industryGroups.join(", "),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Industrial_Group(
                      initialIndustries: industryGroups,
                    ),
                  ),
                );
                if (result != null && result is List<String>) {
                  setState(() {
                    industryGroups = result;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildInputFieldWithNavigation(
              label: '직무 *',
              value: jobDuty.isEmpty ? "입력되지 않음" : jobDuty,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Job_Duty(initialJobDuty: jobDuty),
                  ),
                );
                if (result != null && result is String) {
                  setState(() {
                    jobDuty = result;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildInputFieldWithNavigation(
              label: '활동/경험',
              value: activityExperience.isEmpty
                  ? "선택하지 않음"
                  : "${activityExperience.length}개 활동 입력됨",
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityExperience(),
                  ),
                );
                if (result != null && result is List<Map<String, String>>) {
                  setState(() {
                    activityExperience = result;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildInputFieldWithNavigation(
              label: '역량',
              value: capabilities.isEmpty ? "선택하지 않음" : capabilities.join(", "),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CapabilityPage(
                      initialCapabilities: capabilities,
                    ),
                  ),
                );
                if (result != null && result is List<String>) {
                  setState(() {
                    capabilities = result;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildInputFieldWithNavigation(
              label: '강점',
              value: strengths.isEmpty ? "선택하지 않음" : strengths.join(", "),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StrengthPage(
                      initialStrengths: strengths,
                    ),
                  ),
                );
                if (result != null && result is List<String>) {
                  setState(() {
                    strengths = result;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildInputFieldWithNavigation(
              label: '약점',
              value: weaknesses.isEmpty ? "선택하지 않음" : weaknesses.join(", "),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeaknessPage(
                      initialWeaknesses: weaknesses,
                    ),
                  ),
                );
                if (result != null && result is List<String>) {
                  setState(() {
                    weaknesses = result;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildInputFieldWithNavigation(
              label: '수상경력',
              value: awards.isEmpty ? "선택하지 않음" : "${awards.length}개 입력됨",
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AwardPage(initialAwards: awards),
                  ),
                );
                if (result != null && result is List<Map<String, String>>) {
                  setState(() {
                    awards = result;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildInputFieldWithNavigation(
              label: '자격증',
              value: certificates.isEmpty
                  ? "선택하지 않음"
                  : "${certificates.length}개 입력됨",
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CertificatePage(
                      initialCertificates: certificates,
                    ),
                  ),
                );
                if (result != null && result is List<Map<String, String>>) {
                  setState(() {
                    certificates = result;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildInputFieldWithNavigation(
              label: '어학',
              value: languages.isEmpty ? "선택하지 않음" : "${languages.length}개 입력됨",
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LanguagePage(
                      initialLanguages: languages,
                    ),
                  ),
                );
                if (result != null && result is List<Map<String, String>>) {
                  setState(() {
                    languages = result;
                  });
                }
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            if (resumeTitle.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('이력서 제목을 입력해주세요.'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              Navigator.pop(context, {
                "title": resumeTitle,
                "industries": industryGroups,
                "jobDuty": jobDuty,
                "activityExperience": activityExperience,
                "capabilities": capabilities,
                "strengths": strengths,
                "weaknesses": weaknesses,
                "awards": awards,
                "certificates": certificates,
                "languages": languages,
              });
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
      ),
    );
  }

  Widget _buildInputFieldWithNavigation({
    required String label,
    required String value,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                "$label: $value",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
