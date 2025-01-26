import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv 패키지 추가
import 'dart:convert';

void main() async {
  await dotenv.load(fileName: ".env"); // .env 파일 로드
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
  late SharedPreferences sharedPreferences;
  bool logincheck = false;
  bool _isPasswordVisible = false;

  late String email = ''; // 이메일 초기화
  late String password = ''; // 비밀번호 초기화

  Future<void> login() async {
    // 환경 변수에서 API_BASE_URL 가져오기
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      Get.snackbar(
        "오류",
        "API_BASE_URL 환경 변수가 설정되지 않았습니다.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // URL 생성
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
        Get.snackbar("로그인 성공", "홈 화면으로 이동합니다.",
            snackPosition: SnackPosition.TOP);
        Get.to(() => HomeScreen());
      } else {
        // 서버 에러 처리
        Get.snackbar(
          "로그인 실패",
          '로그인에 실패하였습니다: ${response.body}',
          snackPosition: SnackPosition.TOP,
        );
        print("서버와 통신 실패 (${response.statusCode})");
      }
    } catch (e) {
      // 네트워크 에러 처리
      Get.snackbar(
        "네트워크 에러",
        "서버와 연결할 수 없습니다.",
        snackPosition: SnackPosition.TOP,
      );
      print('문제 : $e');
    }
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
                            email = value; // 이메일 값 저장
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
                            password = value; // 비밀번호 값 저장
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      TextButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            login(); // 로그인 함수 호출
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
                      GestureDetector(
                        child: Text(
                          '비밀번호를 잊어버리셨나요?',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF888888),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '아직 계정이 없으신가요? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            '회원가입',
                            style:
                            TextStyle(color: Color(0xFF878CEF), fontSize: 14),
                          ),
                          onTap: () {
                            Get.to(() => Signup());
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      child: Text(
                        '건너뛰기',
                        style: TextStyle(fontSize: 12, color: Color(0xFFCCCCCC)),
                      ),
                      onTap: () {
                        Get.to(() => HomeScreen());
                      },
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}