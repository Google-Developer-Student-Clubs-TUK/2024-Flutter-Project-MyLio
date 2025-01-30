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
  State<Edit> createState() => Edit_State();
}

class Edit_State extends State<Edit> {
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
                      initialActivities: List<Map<String, String>>.from(
                          resumeData['activityExperience'] ?? []),
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
                      initialAwards: List<Map<String, String>>.from(
                          resumeData['awards'] ?? []),
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
                      initialCertificates: List<Map<String, String>>.from(
                          resumeData['certificates'] ?? []),
                    ),
                  ),
                );
              },
              child: _buildInputField(
                  '자격증',
                  resumeData['certificates']
                          ?.map((certificate) => certificate['name'])
                          .join(', ') ??
                      ''),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String value) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label: $value',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
