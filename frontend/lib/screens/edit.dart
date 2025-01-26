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
  const Edit({Key? key, required resumeId}) : super(key: key);

  @override
  State<Edit> createState() => Edit_State();
}

class Edit_State extends State<Edit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '수정',
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
              child: _buildInputField('이력서 제목 *'),
              onTap: () {
                Get.to(() => Resume_Title(
                      initialTitle: '',
                      title: '',
                    ));
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              child: _buildInputField('산업군 *'),
              onTap: () {
                Get.to(Industrial_Group(
                  initialIndustries: [],
                ));
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              child: _buildInputField('직무 *'),
              onTap: () {
                Get.to(Job_Duty(
                  initialJobDuty: '',
                ));
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              child: _buildInputField('활동/경험'),
              onTap: () {
                Get.to(() => ActivityExperience());
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CapabilityPage(
                      initialCapabilities: [],
                    ),
                  ),
                );
              },
              child: _buildInputField('역량'), // 역량 필드
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AwardPage(
                      initialAwards: [],
                    ),
                  ),
                );
              },
              child: _buildInputField('수상경력'), // 수상경력 필드
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StrengthPage(
                      initialStrengths: [],
                    ),
                  ),
                );
              },
              child: _buildInputField('강점'), // 강점 필드
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WeaknessPage(
                      initialWeaknesses: [],
                    ),
                  ),
                );
              },
              child: _buildInputField('약점'), // 약점 필드
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CertificatePage(
                      initialCertificates: [],
                    ),
                  ),
                );
              },
              child: _buildInputField('자격증'), // 자격증 필드
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguagePage(
                      initialLanguages: [],
                    ),
                  ),
                );
              },
              child: _buildInputField('어학'), // 어학 필드
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            print('저장하기 버튼 클릭');
            Get.to(Add_Resume());
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

  Widget _buildInputField(String label) {
    return Container(
      height: 70, // 상자 높이
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
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
