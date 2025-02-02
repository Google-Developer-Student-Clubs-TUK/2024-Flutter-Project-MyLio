import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:frontend/screens/edit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'my_resume_create_page.dart';
import 'widgets/my_resume_empty_widget.dart';
import 'components/resume_PopupMenu_Btn.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/utils/http_interceptor.dart';

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
      final response = await HttpInterceptor().get(url);

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        // UTF-8로 수동 디코딩
        final decodedBody = utf8.decode(response.bodyBytes);
        print('Response body: $decodedBody');
        final List<dynamic> data = jsonDecode(decodedBody);

        setState(() {
          resumes = data
              .map((resume) => {
                    'resume_id': resume['resumeId'] ?? '',
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
        print('매핑된 resumes 리스트: $resumes');
      } else {
        print('Failed to load resumes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching resumes: $e');
    }
  }

  // 이력서 삭제 API 호출
  Future<void> deleteResume(String userId, String resumeId) async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$baseUrl/api/v1/resume/delete/$userId/$resumeId');

    try {
      final response = await HttpInterceptor().delete(url);

      if (response.statusCode == 200) {
        print('이력서 삭제 성공: $resumeId');

        // 삭제 후 서버에서 최신 데이터를 다시 가져오기
        await fetchUserResumes();
      } else {
        print('이력서 삭제 실패: ${response.body}');
      }
    } catch (e) {
      print('이력서 삭제 중 오류 발생: $e');
    }
  }

  // 대표 이력서 설정 API 호출
  Future<void> setPrimaryResume(String userId, String resumeId) async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    final url =
        Uri.parse('$baseUrl/api/v1/resume/set-primary/$userId/$resumeId');

    print('대표 이력서 설정 요청 URL: $url');

    try {
      final response = await HttpInterceptor().post(url);

      if (response.statusCode == 200) {
        print('대표 이력서 설정 성공: $resumeId');

        // 서버에서 최신 데이터를 다시 가져오기
        await fetchUserResumes();

        setState(() {
          final selectedResume = resumes.firstWhere(
            (resume) => resume['resume_id'].toString() == resumeId,
            orElse: () => <String, dynamic>{}, // 빈 맵을 기본값으로 반환
          );
          if (selectedResume.isNotEmpty) {
            // 빈 맵인지 확인
            resumes.remove(selectedResume);
            resumes.insert(0, selectedResume); // 대표 이력서를 리스트의 첫 번째로 이동
          } else {
            print('대표 이력서를 찾을 수 없습니다. resume_id: $resumeId');
          }
        });
      } else {
        print('대표 이력서 설정 실패: ${response.body}');
      }
    } catch (e) {
      print('대표 이력서 설정 중 오류 발생: $e');
    }
  }

  // 이력서 복사 API 호출
  Future<void> duplicateResume(String userId, String resumeId) async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$baseUrl/api/v1/resume/copy/$userId/$resumeId');

    print('이력서 복사 요청 (PUT) URL: $url');

    try {
      final response = await HttpInterceptor().put(url);

      print('이력서 복사 응답 코드: ${response.statusCode}');
      print('이력서 복사 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        print('이력서 복사 성공: $resumeId');

        // 응답 본문이 비어 있는 경우, 리스트 전체를 다시 로드
        if (response.body.isEmpty) {
          print('⚠ 서버 응답이 비어 있음. 이력서 목록을 다시 불러옵니다.');
          await fetchUserResumes(); // 서버에서 전체 이력서를 다시 가져옴
          return;
        }

        try {
          final decodedBody = utf8.decode(response.bodyBytes);
          final Map<String, dynamic> newResume = jsonDecode(decodedBody);

          setState(() {
            resumes.insert(0, {
              'resume_id': newResume['resumeId'] ?? '',
              'title': newResume['resumeTitle'] ?? 'Untitled',
              'isPrimary': newResume['isPrimary'] ?? false,
              'industries':
                  List<String>.from(newResume['industryGroups'] ?? []),
              'jobDuty': newResume['jobDuty'] ?? '',
              'capabilities':
                  List<String>.from(newResume['capabilities'] ?? []),
              'strengths': List<String>.from(newResume['strengths'] ?? []),
              'weaknesses': List<String>.from(newResume['weaknesses'] ?? []),
              'activityExperience': List<Map<String, dynamic>>.from(
                  newResume['activityExperience'] ?? []),
              'awards':
                  List<Map<String, dynamic>>.from(newResume['awards'] ?? []),
              'certificates': List<Map<String, dynamic>>.from(
                  newResume['certificates'] ?? []),
              'languages':
                  List<Map<String, dynamic>>.from(newResume['languages'] ?? []),
            });
          });
        } catch (e) {
          print('⚠ JSON 파싱 중 오류 발생: $e');
          print('⚠ 서버에서 반환된 데이터가 올바른 JSON 형식인지 확인 필요.');
          await fetchUserResumes(); // 오류 발생 시 최신 리스트 다시 불러오기
        }
      } else {
        print('❌ 이력서 복사 실패: ${response.body}');
      }
    } catch (e) {
      print('❌ 이력서 복사 중 오류 발생: $e');
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
                              final resumeId = resume['resume_id'];
                              print('resume_id: $resumeId'); // resume_id 출력
                              if (resumeId != null &&
                                  resumeId.toString().isNotEmpty) {
                                setPrimaryResume('1',
                                    resumeId.toString()); // userId와 resumeId 전달
                              }
                            },
                            onEdit: () async {
                              final updatedResume =
                                  await Get.to(() => Edit(resumeData: resume));

                              if (updatedResume != null &&
                                  updatedResume is Map<String, dynamic>) {
                                setState(() {
                                  final index = resumes.indexWhere((r) =>
                                      r['resume_id'].toString() ==
                                      updatedResume['resume_id'].toString());
                                  if (index != -1) {
                                    resumes[index] =
                                        updatedResume; // 기존 데이터를 업데이트
                                  }
                                });
                              }
                            },
                            onDelete: () async {
                              final resumeId = resume['resume_id'];
                              if (resumeId != null &&
                                  resumeId.toString().isNotEmpty) {
                                await deleteResume('1', resumeId.toString());
                              }
                            },
                            onDuplicate: () async {
                              final resumeId = resume['resume_id'];
                              if (resumeId != null &&
                                  resumeId.toString().isNotEmpty) {
                                await duplicateResume('1', resumeId.toString());
                              }
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
                      if (resume['capabilities'] != null &&
                          resume['capabilities'].isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          '역량: ${resume['capabilities'].join(', ')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      if (resume['strengths'] != null &&
                          resume['strengths'].isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          '강점: ${resume['strengths'].join(', ')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      if (resume['weaknesses'] != null &&
                          resume['weaknesses'].isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          '약점: ${resume['weaknesses'].join(', ')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      if (resume['activityExperience'] != null &&
                          resume['activityExperience'].isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          '활동/경험: ${resume['activityExperience'].map((activity) => activity['name']).join(', ')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      if (resume['awards'] != null &&
                          resume['awards'].isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          '수상경력: ${resume['awards'].map((award) => award['name']).join(', ')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      if (resume['certificates'] != null &&
                          resume['certificates'].isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          '자격증: ${resume['certificates'].map((certificate) => certificate['name']).join(', ')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      if (resume['languages'] != null &&
                          resume['languages'].isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          '어학: ${resume['languages'].map((language) => language['language']).join(', ')}',
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
