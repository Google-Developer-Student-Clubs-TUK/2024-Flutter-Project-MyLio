import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'my_resume_create_page.dart';
import 'widgets/my_resume_empty_widget.dart';
import 'components/resume_PopupMenu_Btn.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyResumeScreen extends StatefulWidget {
  const MyResumeScreen({Key? key, required this.resumeTitle}) : super(key: key);

  final String resumeTitle;

  @override
  State<MyResumeScreen> createState() => _MyResumeScreenState();
}

class _MyResumeScreenState extends State<MyResumeScreen> {
  List<Map<String, dynamic>> resumes = []; // 이력서 데이터 리스트

  @override
  void initState() {
    super.initState();
    fetchUserResumes(); // 이력서 데이터 가져오기
  }

  // 서버에서 유저의 이력서 목록 가져오기
  Future<void> fetchUserResumes() async {
    const userId = '1';
    final baseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$baseUrl/api/v1/resume/user/$userId');

    try {
      final accessToken =
          dotenv.env['ACCESS_TOKEN']; // .env에서 ACCESS_TOKEN 가져오기

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        // UTF-8로 수동 디코딩
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decodedBody);

        setState(() {
          resumes = data
              .map((resume) => {
                    'resume_id': resume['resume_id'] ?? '',
                    'title': resume['resumeTitle'] ?? 'Untitled',
                    'industries':
                        List<String>.from(resume['industryGroups'] ?? []),
                    'jobDuty': resume['jobDuty'] ?? '',
                    'capabilities':
                        List<String>.from(resume['capabilities'] ?? []),
                    'strengths': List<String>.from(resume['strengths'] ?? []),
                    'weaknesses': List<String>.from(resume['weaknesses'] ?? []),
                    'activityExperience': List<Map<String, dynamic>>.from(
                        resume['activityExperience'] ?? []),
                    'awards':
                        List<Map<String, dynamic>>.from(resume['awards'] ?? []),
                    'certificates': List<Map<String, dynamic>>.from(
                        resume['certificates'] ?? []),
                    'languages': List<Map<String, dynamic>>.from(
                        resume['languages'] ?? []),
                  })
              .toList();
        });
      } else {
        print('Failed to load resumes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching resumes: $e');
    }
  }

  // 새로운 이력서를 추가하는 메서드
  void addResume(
    String newResumeTitle,
    List<String> industries,
    String jobDuty,
    List<String> capabilities,
    List<String> strengths,
    List<String> weaknesses,
    List<Map<String, String>> activityExperience,
    List<Map<String, String>> awards,
    List<Map<String, String>> certificates,
    List<Map<String, String>> languages,
  ) {
    setState(() {
      resumes.add({
        'resume_id': DateTime.now().toString(), // 임시 ID 생성
        'title': newResumeTitle,
        'industries': industries,
        'jobDuty': jobDuty,
        'capabilities': capabilities,
        'strengths': strengths,
        'weaknesses': weaknesses,
        'activityExperience': activityExperience,
        'awards': awards,
        'certificates': certificates,
        'languages': languages,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My 이력서',
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
      // 이력서가 없을 때 화면
      body: resumes.isEmpty
          ? MyResumeEmptyWidget(
              onResumeAdded: (
                title,
                industries,
                jobDuty,
                capabilities,
                strengths,
                weaknesses,
                activityExperience,
                awards,
                certificates,
                languages,
              ) {
                addResume(
                  title,
                  industries,
                  jobDuty,
                  capabilities,
                  strengths,
                  weaknesses,
                  activityExperience,
                  awards,
                  certificates,
                  languages,
                );
              },
            )
          : _buildResumeList(context),
    );
  }

  // 이력서가 있을 때 화면
  Widget _buildResumeList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: resumes.length,
              itemBuilder: (context, index) {
                final resume = resumes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  width: 352,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(251, 251, 251, 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 57.31,
                            height: 18,
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? const Color.fromRGBO(144, 140, 255, 1)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              index == 0 ? '대표 이력서' : '이력서',
                              style: TextStyle(
                                color: index == 0 ? Colors.white : Colors.black,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          ResumePopupMenuBtn(
                            onSetRepresentative: () {
                              setState(() {
                                final selectedResume = resumes.removeAt(index);
                                resumes.insert(0, selectedResume);
                              });
                            },
                            onEdit: () {
                              Get.to(() => MyResumeCreatePage());
                            },
                            onDelete: () {
                              setState(() {
                                resumes.removeAt(index);
                              });
                            },
                            onDuplicate: () {
                              setState(() {
                                resumes.insert(
                                    index + 1, Map.from(resumes[index]));
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ID: ${resume['resume_id']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        resume['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (resume['industries'] != null &&
                          resume['industries'].isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          '산업군: ${resume['industries'].join(', ')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      if (resume['jobDuty'] != null &&
                          resume['jobDuty'].isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          '직무: ${resume['jobDuty']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyResumeCreatePage(),
                ),
              );
              if (result != null && result is Map<String, dynamic>) {
                addResume(
                  result['title'],
                  result['industries'],
                  result['jobDuty'],
                  result['capabilities'],
                  result['strengths'],
                  result['weaknesses'],
                  result['activityExperience'],
                  result['awards'],
                  result['certificates'],
                  result['languages'],
                );
              }
            },
            child: DottedBorder(
              color: Colors.grey,
              strokeWidth: 1,
              dashPattern: [2, 2],
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: Container(
                width: 352,
                height: 47,
                alignment: Alignment.center,
                child: const Text(
                  '+ 이력서 추가',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
