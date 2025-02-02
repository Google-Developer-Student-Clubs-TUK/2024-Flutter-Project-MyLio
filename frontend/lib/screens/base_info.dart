import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class Base_Info extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Base_Info_State();
  }
}

class Base_Info_State extends State<Base_Info> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String nameHint = "이름을 입력하세요"; // 기본 힌트 텍스트
  String phoneHint = "전화번호를 입력하세요"; // 기본 힌트 텍스트
  String emailHint = "이메일을 입력하세요"; // 기본 힌트 텍스트
  final TextEditingController passwordController = TextEditingController(); // 비밀번호 입력 필드
  final TextEditingController confirmPasswordController = TextEditingController(); // 비밀번호 확인 입력 필드

  bool _isPasswordVisible = false; // 비밀번호 표시 여부

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      print("API_BASE_URL 환경 변수가 설정되지 않았습니다.");
      return;
    }

    // SecureStorage에서 USER_ID와 ACCESS_TOKEN 가져오기
    String? userId = await secureStorage.read(key: "user_id");
    String? accessToken = await secureStorage.read(key: "jwt_token");

    if (userId == null || accessToken == null) {
      print("USER_ID 또는 ACCESS_TOKEN이 없습니다.");
      return;
    } else {
      print(userId);
      print(accessToken);
    }

    final url = Uri.parse("$baseUrl/api/v1/user/$userId");

    try {
      print(url);
      final response = await http.get(
        url,
        headers: {
          "userId": userId,
          "accessToken": accessToken,
        },
      );
      print(response);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          nameHint = data['name'] ?? nameHint; // 서버에서 가져온 이름
          phoneHint = data['phoneNumber'] ?? phoneHint; // 서버에서 가져온 전화번호
          emailHint = data['email'] ?? emailHint; // 서버에서 가져온 이메일
        });
      } else {
        print('사용자 정보 로드 실패: ${response.body}');
        print(response.statusCode);
      }
    } catch (e) {
      print('오류 발생: $e');
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
                  // 이름
                  Text(
                    '이름',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 352,
                    height: 47,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: nameHint,
                        hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // 전화번호
                  Text(
                    '전화번호',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 352,
                    height: 47,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: phoneHint,
                        hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // 이메일
                  Text(
                    '이메일',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 352,
                    height: 47,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: emailHint,
                        hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // 비밀번호
                  Text(
                    '비밀번호',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 352,
                    height: 47,
                    child: TextFormField(
                      controller: passwordController,
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
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // 비밀번호 확인
                  Text(
                    '비밀번호 확인',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 352,
                    height: 47,
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: "****",
                        hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Spacer(),
            // 수정 완료 버튼
            Center(
              child: TextButton(
                onPressed: () {
                  // 비밀번호와 비밀번호 확인이 일치하는지 검증
                  if (passwordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("비밀번호와 비밀번호 확인이 일치하지 않습니다."),
                      ),
                    );
                    return;
                  }
                  print("수정 완료 버튼 클릭");
                  // 여기서 추가로 서버에 수정 요청 등을 진행할 수 있습니다.
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
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}