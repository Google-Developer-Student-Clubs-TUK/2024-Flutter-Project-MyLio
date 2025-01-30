import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv 패키지 추가
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure Storage 추가
import 'dart:convert';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(Login());
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(); // Secure Storage 인스턴스 생성
  late SharedPreferences sharedPreferences;
  bool logincheck = false;
  bool _isPasswordVisible = false;

  late String email = ''; // 이메일 초기화
  late String password = ''; // 비밀번호 초기화

  Future<void> login() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      Get.snackbar(
        "오류",
        "API_BASE_URL 환경 변수가 설정되지 않았습니다.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final url = Uri.parse("$baseUrl/api/v1/auth/user");

    try {
      final response = await http.get(
        url,
        headers: {
          "email": email,
          "pw": password,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          String? jwtToken = _extractJwtFromCookie(cookies);

          if (jwtToken != null) {
            // JWT 토큰을 flutter_secure_storage에 저장
            await secureStorage.write(key: "jwt_token", value: jwtToken);
            print("JWT 저장 완료: $jwtToken");

            Get.snackbar("로그인 성공", "홈 화면으로 이동합니다.",
                snackPosition: SnackPosition.TOP);
            Get.to(() => HomeScreen());
            return;
          }
        }

        Get.snackbar("로그인 실패", "JWT 토큰을 찾을 수 없습니다.",
            snackPosition: SnackPosition.TOP);
      } else {
        Get.snackbar(
          "로그인 실패",
          '로그인에 실패하였습니다: ${response.body}',
          snackPosition: SnackPosition.TOP,
        );
        print("서버와 통신 실패 (${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar(
        "네트워크 에러",
        "서버와 연결할 수 없습니다.",
        snackPosition: SnackPosition.TOP,
      );
      print('문제 : $e');
    }
  }

  /// 🔹 쿠키에서 JWT 토큰 추출하는 함수
  String? _extractJwtFromCookie(String cookie) {
    List<String> cookies = cookie.split("; ");
    for (String c in cookies) {
      if (c.startsWith("ACCESS_TOKEN=")) { // 기존 jwt= 에서 ACCESS_TOKEN=으로 변경
        return c.split("=")[1]; // JWT 토큰 값 추출
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '로그인',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 30),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 323,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "이메일",
                            hintStyle: TextStyle(fontSize: 12),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 323,
                        child: TextFormField(
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                              hintText: "비밀번호",
                              hintStyle: TextStyle(fontSize: 12),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
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
                                    color: Color(0xFFC1C7D0),
                                  ))),
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      TextButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            login();
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF878CEF),
                          minimumSize: Size(352, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "로그인",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}