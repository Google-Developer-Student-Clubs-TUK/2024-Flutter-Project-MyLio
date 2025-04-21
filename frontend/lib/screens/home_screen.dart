import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/utils/http_interceptor.dart';
import 'package:http/http.dart' as http;

import 'components/bottom_bar.dart';
import 'components/introduction_list_PopupMeun_Btn.dart';
import 'question_insert.dart';
import 'setting_screen.dart';
import 'theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> coverLetters = []; // API 원본 데이터
  List<String> resumes = []; // UI에 뿌릴 제목 목록
  bool isLoading = true;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final HttpInterceptor interceptor = HttpInterceptor();

  @override
  void initState() {
    super.initState();
    fetchCoverLetters();
  }

  Future<void> fetchCoverLetters() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("❌ API_BASE_URL 환경 변수가 설정되지 않았습니다.");
      setState(() => isLoading = false);
      return;
    }

    // JWT
    final String? accessToken = await secureStorage.read(key: "jwt_token");
    if (accessToken == null) {
      print("❌ 저장된 ACCESS_TOKEN이 없습니다.");
      setState(() => isLoading = false);
      return;
    }

    // 새 엔드포인트: /api/v1/coverLetters/my?accessToken=<JWT>
    final url =
        Uri.parse("$baseUrl/api/v1/coverLetters/my?accessToken=$accessToken");

    try {
      // 인터셉터를 통해 Authorization / Cookie 헤더 자동 첨부
      final response = await interceptor.get(url);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decodedBody);

        setState(() {
          coverLetters = data;
          resumes = data
              .map<String>((item) => item['title']?.toString() ?? "제목 없음")
              .toList();
          isLoading = false;
        });

        print("✅ 불러온 제목 목록: $resumes");
      } else {
        print("❌ API 호출 실패: ${response.statusCode} - ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("❌ 네트워크 오류: $e");
      setState(() => isLoading = false);
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('도움말'),
        content: const Text(
          'MyLio는 이력서 기반으로 AI가 \n자기소개서를 생성해주는 서비스 입니다. \n\n'
          '중앙의 + 버튼을 누르면 자기소개서가 생성됩니다. \n\n'
          '왼쪽 아이콘에서 자기소개서 목록을 확인하고, \n오른쪽 아이콘에서는 이력서를 생성할 수 있습니다.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 1) 자기소개서가 있는 경우 → 리스트 출력

    if (coverLetters.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: resumes.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            width: MediaQuery.of(context).size.width * 0.9,
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff8978EB), Color(0xffDAD8FF)],
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
                    padding: const EdgeInsets.only(left: 10.0, right: 16.0),
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
                IntroductionListPopupMenuBtn(
                  resumeTitle: resumes[index],
                  coverLetters: coverLetters,
                ),
              ],
            ),
          );
        },
      );
    }

    // 2) 자기소개서가 없는 경우 → 기본 홈 화면(로고) 표시

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Gradients.blue.withOpacity(0.5),
                Gradients.purple.withOpacity(0.5),
                Gradients.pink.withOpacity(0.5),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ).createShader(bounds),
            child: Image.asset(
              'assets/images/logo.png',
              width: 154,
              height: 154,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String appBarTitle =
        coverLetters.isNotEmpty ? 'AI 자기소개서 목록' : 'MyLio';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          appBarTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: coverLetters.isNotEmpty
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.black),
                  onPressed: _showHelpDialog,
                ),
              ],
      ),
      backgroundColor: Colors.white,
      body: _buildBodyContent(),

      //Floating FAB
      floatingActionButton: Container(
        height: 70.0,
        width: 70.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Gradients.blue, Gradients.purple, Gradients.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          elevation: 0,
          highlightElevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.add, size: 41, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuestionInsert()),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      //Bottom Navigation
      bottomNavigationBar: BottomBar(
        isHomeScreen: true,
        onLeftIconPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        onSettingsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingScreen()),
          );
        },
        onFabPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuestionInsert()),
          );
        },
      ),
    );
  }
}
