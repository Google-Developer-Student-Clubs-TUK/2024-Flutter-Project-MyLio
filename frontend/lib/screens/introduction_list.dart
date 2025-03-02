import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/screens/components/introduction_list_PopupMeun_Btn.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IntroductionList extends StatefulWidget {
  const IntroductionList({super.key});

  @override
  State<IntroductionList> createState() => _IntroductionListState();
}

class _IntroductionListState extends State<IntroductionList> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  List<String> resumes = []; // 제목만 저장
  List<dynamic> coverLetters = []; // 전체 자기소개서 데이터 저장

  @override
  void initState() {
    super.initState();
    fetchTitles(); // API 호출하여 데이터 가져오기
  }

  // API 호출: userId 기반 자기소개서 목록 가져오기
  Future<void> fetchTitles() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("❌ API_BASE_URL 환경 변수가 설정되지 않았습니다.");
      return;
    }

    final String? userId = await secureStorage.read(key: "user_id");
    if (userId == null) {
      print("❌ 저장된 user_id를 찾을 수 없습니다.");
      return;
    }

    final url = Uri.parse("$baseUrl/api/v1/coverLetters/user/$userId");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // 한글 깨짐 방지를 위해 utf8.decode 사용
        final String decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> responseData = jsonDecode(decodedBody);

        // title만 추출하여 리스트에 저장
        List<String> extractedTitles = responseData
            .map<String>((item) => item['title']?.toString() ?? "제목 없음")
            .toList();

        setState(() {
          coverLetters = responseData;
          resumes = extractedTitles;
        });

        print("✅ 불러온 제목 목록: $resumes");
      } else {
        print("❌ API 호출 실패: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ 네트워크 오류: $e");
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
          '자기소개서 목록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: resumes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: resumes.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff8978EB),
                        Color(0xffDAD8FF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 16.0),
                          child: Text(
                            resumes[index],
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      // onModifyPressed 파라미터를 제거하여 기본 동작(내부 수정 로직)이 실행되도록 함
                      IntroductionListPopupMenuBtn(
                        resumeTitle: resumes[index],
                        coverLetters: coverLetters,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
