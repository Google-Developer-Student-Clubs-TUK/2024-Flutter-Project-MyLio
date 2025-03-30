import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/utils/http_interceptor.dart';
import 'package:frontend/screens/login.dart';

class Base_Info extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Base_Info_State();
  }
}

class Base_Info_State extends State<Base_Info> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String nameHint = "이름을 입력하세요";
  String phoneHint = "전화번호를 입력하세요";
  String emailHint = "이메일을 입력하세요";
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("🚨 API_BASE_URL 환경 변수가 설정되지 않았습니다.");
      return;
    }

    String? userId = await secureStorage.read(key: "user_id");

    if (userId == null) {
      print("🚨 USER_ID가 없습니다.");
      return;
    }

    final url = Uri.parse("$baseUrl/api/v1/user/$userId");

    try {
      print("🔗 요청 URL: $url");
      final response = await HttpInterceptor().get(url);
      print(response);

      if (response.statusCode == 200) {
        // 응답을 UTF-8로 디코딩하여 한글 인코딩 문제 해결
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          nameHint = data['name'] ?? nameHint;
          phoneHint = data['phoneNumber'] ?? phoneHint;
          emailHint = data['email'] ?? emailHint;
        });
      } else {
        print('🚨 사용자 정보 로드 실패: ${response.body}');
        print(response.statusCode);
      }
    } catch (e) {
      print('⚠️ 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '기본 정보',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField("이름", nameHint),
                  SizedBox(height: 20),
                  _buildInputField("전화번호", phoneHint),
                  SizedBox(height: 20),
                  _buildInputField("이메일", emailHint),
                  SizedBox(height: 20),
                  _buildPasswordField("비밀번호", passwordController),
                  SizedBox(height: 20),
                  _buildPasswordField("비밀번호 확인", confirmPasswordController),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Spacer(),
            // 로그아웃 버튼을 수정완료 버튼 위에 배치
            _buildLogoutButton(),
            SizedBox(height: 40),
            _buildSubmitButton(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// 입력 필드 위젯 생성 함수 (이름, 전화번호, 이메일)
  Widget _buildInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 352,
          height: 47,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 비밀번호 입력 필드 위젯 생성 함수
  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 352,
          height: 47,
          child: TextFormField(
            controller: controller,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: "****",
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Color(0xFFCCCCCC),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 수정 완료 버튼 위젯
  Widget _buildSubmitButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          // 비밀번호와 비밀번호 확인이 일치하는지 검증
          if (passwordController.text != confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("🚨 비밀번호와 비밀번호 확인이 일치하지 않습니다."),
              ),
            );
            return;
          }
          print("✅ 수정 완료 버튼 클릭");
        },
        style: TextButton.styleFrom(
          backgroundColor: Color(0xFF878CEF),
          minimumSize: Size(352, 47),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "수정완료",
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  /// 로그아웃 버튼 위젯 생성 함수 (수정완료 버튼 위에 배치)
  Widget _buildLogoutButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          // 로그아웃 확인 다이얼로그
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("로그아웃"),
                content: Text("로그아웃을 정말 하시겠습니까?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 취소 시 다이얼로그 닫기
                    },
                    child: Text("취소"),
                  ),
                  TextButton(
                    onPressed: () async {
                      // 확인 시 SecureStorage에 저장된 사용자 정보 삭제 후 Login 화면으로 이동
                      await secureStorage.deleteAll();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Text("확인"),
                  ),
                ],
              );
            },
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[200], // 연한 회색 배경
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // 작게 줄임
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          '로그아웃',
          style: TextStyle(
            fontSize: 14, // 폰트 크기 작게
            color: Colors.grey, // 진한 회색 텍스트
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
