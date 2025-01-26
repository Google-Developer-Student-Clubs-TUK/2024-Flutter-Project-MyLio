import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
import 'my_resume_screen.dart'; // 추가된 import

class MyResumeCreatePage extends StatefulWidget {
  const MyResumeCreatePage({Key? key}) : super(key: key);

  @override
  State<MyResumeCreatePage> createState() => _MyResumeCreatePageState();
}

class _MyResumeCreatePageState extends State<MyResumeCreatePage> {
  String resumeTitle = "";
  List<String> industryGroups = [];
  String jobDuty = "";
  List<Map<String, String>> activityExperience = [];
  List<String> capabilities = [];
  List<String> strengths = [];
  List<String> weaknesses = [];
  List<Map<String, String>> awards = [];
  List<Map<String, String>> certificates = [];
  List<Map<String, String>> languages = [];

  Future<void> saveResumeWithToken(String accessToken) async {
    final String? baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("Base URL is null. Check .env file.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('환경 변수를 확인해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    const userId = "1";
    final url = Uri.parse('$baseUrl/api/v1/resume/create/$userId');

    final List<Map<String, String>> formattedActivityExperience =
        activityExperience.map((experience) {
      return {
        "name": experience["name"] ?? "",
        "organization": experience["organization"] ?? "",
        "startDate": experience["startDate"] ?? "",
        "endDate": experience["endDate"] ?? "",
        "description": experience["description"] ?? "",
      };
    }).toList();

    final List<Map<String, String>> formattedAwards = awards.map((award) {
      return {
        "name": award["name"] ?? "",
        "organization": award["organization"] ?? "",
        "date": award["date"] ?? "",
        "description": award["description"] ?? "",
      };
    }).toList();

    final List<Map<String, String>> formattedCertificates =
        certificates.map((certificate) {
      return {
        "name": certificate["name"] ?? "",
        "date": certificate["date"] ?? "",
        "issuer": certificate["issuer"] ?? "",
      };
    }).toList();

    final List<Map<String, String>> formattedLanguages =
        languages.map((language) {
      return {
        "language": language["language"] ?? "",
        "exam": language["exam"] ?? "",
        "score": language["score"] ?? "",
        "date": language["date"] ?? "",
      };
    }).toList();

    final requestBody = {
      "resumeTitle": resumeTitle,
      if (industryGroups.isNotEmpty) "industryGroups": industryGroups,
      if (jobDuty.isNotEmpty) "jobDuty": jobDuty,
      if (activityExperience.isNotEmpty)
        "activityExperience": formattedActivityExperience,
      if (awards.isNotEmpty) "awards": formattedAwards,
      if (certificates.isNotEmpty) "certificates": formattedCertificates,
      if (languages.isNotEmpty) "languages": formattedLanguages,
      if (strengths.isNotEmpty) "strengths": strengths,
      if (weaknesses.isNotEmpty) "weaknesses": weaknesses,
      if (capabilities.isNotEmpty) "capabilities": capabilities,
    };

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Cookie': 'ACCESS_TOKEN=$accessToken; Path=/api/v1/auth',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        print("이력서 저장 성공!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('이력서가 성공적으로 저장되었습니다!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MyResumeScreen(
                    resumeTitle: '',
                  )),
        );
      } else {
        print("이력서 저장 실패: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이력서 저장 실패: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류 발생: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
          onPressed: () async {
            if (resumeTitle.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('이력서 제목을 입력해주세요.'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              final String? accessToken = dotenv.env['ACCESS_TOKEN'];
              if (accessToken != null && accessToken.isNotEmpty) {
                await saveResumeWithToken(accessToken);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('토큰을 확인해주세요.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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
