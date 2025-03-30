import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:frontend/screens/edit.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'my_resume_create_page.dart';
import 'widgets/my_resume_empty_widget.dart';
import 'components/resume_PopupMenu_Btn.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/utils/http_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyResumeScreen extends StatefulWidget {
  const MyResumeScreen({Key? key, required this.resumeTitle}) : super(key: key);

  final String resumeTitle;

  @override
  State<MyResumeScreen> createState() => _MyResumeScreenState();
}

class _MyResumeScreenState extends State<MyResumeScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? _userId; // secureStorage에서 가져온 userId
  List<Map<String, dynamic>> resumes = []; // 이력서 데이터 리스트

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // secureStorage에서 userId 가져온 후 이력서 목록 로드
  }

  /// secureStorage에서 user_id를 읽어온 후, 이력서 데이터를 로드합니다.
  Future<void> _loadUserInfo() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("🚨 API_BASE_URL 환경 변수가 설정되지 않았습니다.");
      return;
    }

    // FlutterSecureStorage에서 user_id 가져오기
    String? userId = await secureStorage.read(key: "user_id");
    print("🔍 저장된 user_id: $userId"); // ✅ 디버깅용 로그 추가

    if (userId == null) {
      print("🚨 USER_ID가 없습니다.");
      return;
    }

    setState(() {
      _userId = userId;
    });

    // userId를 가져온 후 이력서 목록을 불러옵니다.
    await fetchUserResumes();
  }

  /// 서버에서 secureStorage에 저장된 user_id에 해당하는 이력서 목록을 가져옵니다.
  Future<void> fetchUserResumes() async {
    if (_userId == null) {
      print("🚨 userId가 아직 로드되지 않았습니다.");
      return;
    }

    final baseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$baseUrl/api/v1/resume/user/$_userId');

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

  /// 이력서 삭제 API 호출
  Future<void> deleteResume(String resumeId) async {
    if (_userId == null) return;

    final baseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$baseUrl/api/v1/resume/delete/$_userId/$resumeId');

    try {
      final response = await HttpInterceptor().delete(url);

      if (response.statusCode == 200) {
        print('이력서 삭제 성공: $resumeId');
        await fetchUserResumes(); // 삭제 후 최신 데이터 로드
      } else {
        print('이력서 삭제 실패: ${response.body}');
      }
    } catch (e) {
      print('이력서 삭제 중 오류 발생: $e');
    }
  }

  /// 대표 이력서 설정 API 호출
  Future<void> setPrimaryResume(String resumeId) async {
    if (_userId == null) return;

    final baseUrl = dotenv.env['API_BASE_URL'];
    final url =
        Uri.parse('$baseUrl/api/v1/resume/set-primary/$_userId/$resumeId');

    print('대표 이력서 설정 요청 URL: $url');

    try {
      final response = await HttpInterceptor().post(url);

      if (response.statusCode == 200) {
        print('대표 이력서 설정 성공: $resumeId');
        await fetchUserResumes(); // 서버에서 최신 데이터 로드

        setState(() {
          final selectedResume = resumes.firstWhere(
            (resume) => resume['resume_id'].toString() == resumeId,
            orElse: () => <String, dynamic>{}, // 빈 맵 반환
          );
          if (selectedResume.isNotEmpty) {
            resumes.remove(selectedResume);
            resumes.insert(0, selectedResume); // 대표 이력서를 리스트 맨 앞에 배치
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

  /// 이력서 복사 API 호출
  Future<void> duplicateResume(String resumeId) async {
    if (_userId == null) return;

    final baseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$baseUrl/api/v1/resume/copy/$_userId/$resumeId');

    print('이력서 복사 요청 (PUT) URL: $url');

    try {
      final response = await HttpInterceptor().put(url);

      print('이력서 복사 응답 코드: ${response.statusCode}');
      print('이력서 복사 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        print('이력서 복사 성공: $resumeId');

        // 응답 본문이 비어 있으면 전체 목록 다시 로드
        if (response.body.isEmpty) {
          print('⚠ 서버 응답이 비어 있음. 이력서 목록을 다시 불러옵니다.');
          await fetchUserResumes();
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
          await fetchUserResumes();
        }
      } else {
        print('❌ 이력서 복사 실패: ${response.body}');
      }
    } catch (e) {
      print('❌ 이력서 복사 중 오류 발생: $e');
    }
  }

  /// 새로운 이력서를 추가하는 메서드 (임시로 로컬에 추가)
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

      // 이력서가 없을 때 보여줄 위젯
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

  /// 이력서가 있을 때 보여줄 리스트
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
                              if (resumeId != null &&
                                  resumeId.toString().isNotEmpty) {
                                setPrimaryResume(resumeId.toString());
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
                                    resumes[index] = updatedResume;
                                  }
                                });
                              }
                            },
                            onDelete: () async {
                              final resumeId = resume['resume_id'];
                              if (resumeId != null &&
                                  resumeId.toString().isNotEmpty) {
                                await deleteResume(resumeId.toString());
                              }
                            },
                            onDuplicate: () async {
                              final resumeId = resume['resume_id'];
                              if (resumeId != null &&
                                  resumeId.toString().isNotEmpty) {
                                await duplicateResume(resumeId.toString());
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
