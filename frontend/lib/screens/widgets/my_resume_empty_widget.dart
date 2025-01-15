import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../my_resume_create_page.dart';

class MyResumeEmptyWidget extends StatelessWidget {
  final Function(
    String, // 이력서 제목
    List<String>, // 산업군
    String, // 직무
    List<String>, // 역량
    List<String>, // 강점
    List<String>, // 약점
    List<Map<String, String>>, // 활동/경험
    List<Map<String, String>>, // 수상경력
    List<Map<String, String>>, // 자격증
    List<Map<String, String>>, // 어학
  ) onResumeAdded;

  const MyResumeEmptyWidget({Key? key, required this.onResumeAdded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 30, // 상단 여백 및 좌우 마진 추가
      ),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyResumeCreatePage(),
            ),
          );

          if (result != null &&
              result is Map<String, dynamic> &&
              result['title'] != null &&
              result['industries'] != null &&
              result['jobDuty'] != null &&
              result['capabilities'] != null &&
              result['strengths'] != null &&
              result['weaknesses'] != null &&
              result['activityExperience'] != null &&
              result['awards'] != null &&
              result['certificates'] != null &&
              result['languages'] != null) {
            // 모든 데이터 전달
            onResumeAdded(
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
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[400]!,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DottedBorder(
                  color: Colors.grey[300]!,
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  dashPattern: [6, 3],
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '이력서 등록하러 가기',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
