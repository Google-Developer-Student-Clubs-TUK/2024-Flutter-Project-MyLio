import 'package:flutter/material.dart';
import 'package:frontend/activity&experience.dart';
import 'industrial_group.dart';
import 'job_duty.dart';
import 'resume_title.dart';
import 'package:get/get.dart';
import 'capability_page.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyResumeCreatePage(),
  ));
}

class MyResumeCreatePage extends StatefulWidget {
  const MyResumeCreatePage({Key? key}) : super(key: key);

  @override
  State<MyResumeCreatePage> createState() => _MyResumeCreatePageState();
}

class _MyResumeCreatePageState extends State<MyResumeCreatePage> {
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  Resume_Title(),
                  ),
                );
              },
              child: _buildInputField('이력서 제목 *'), // 역량 필드
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  Industrial_Group(),
                  ),
                );
              },
              child: _buildInputField('산업군 *'), // 역량 필드
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  Job_Duty(),
                  ),
                );
              },
              child: _buildInputField('직무 *'), // 역량 필드
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  Activity_Experience(),
                  ),
                );
              },
              child: _buildInputField('활동/경험'), // 역량 필드
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CapabilityPage(),
                  ),
                );
              },
              child: _buildInputField('역량'), // 역량 필드
            ),
            const SizedBox(height: 16),
            _buildInputField('수상경력'),
            const SizedBox(height: 16),
            _buildInputField('강점'),
            const SizedBox(height: 16),
            _buildInputField('약점'),
            const SizedBox(height: 16),
            _buildInputField('자격증'),
            const SizedBox(height: 16),
            _buildInputField('어학'),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            print('저장하기 버튼 클릭');
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
