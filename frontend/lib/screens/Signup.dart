import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv import
import '../../../utils/http_interceptor.dart';
import 'login.dart';

void main() async {
  // 환경 변수 로드
  await dotenv.load(fileName: ".env");
  runApp(Signup());
}

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<Signup> {
  final _formkey = GlobalKey<FormState>();
  bool logincheck = false;
  bool isChecked = false; // 체크박스 상태 관리
  bool _isPasswordVisible = false;

  late String name = '';
  late String phone = '';
  late String email = '';
  late String password = '';

  final HttpInterceptor httpInterceptor = HttpInterceptor();

  Future<void> signup() async {
    final baseUrl = dotenv.env['API_BASE_URL'];

    if (baseUrl == null) {
      Get.snackbar(
        "오류",
        "환경 변수를 확인해주세요.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // 약관 미동의 시 에러 처리
    if (!isChecked) {
      Get.snackbar(
        "오류",
        "이용 약관에 동의해주세요.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // 필드가 하나라도 비어있으면 에러 처리
    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "오류",
        "모든 필드를 입력해주세요.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final url = Uri.parse("$baseUrl/api/v1/auth/user");

    try {
      final response = await httpInterceptor.post(
        url,
        body: {
          "name": name,
          "phoneNumber": phone,
          "email": email,
          "password": password,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 회원가입 성공 시 스낵바를 띄우고 로그인 화면으로 이동
        Get.snackbar(
          "회원가입 성공",
          "로그인 화면으로 이동합니다.",
          snackPosition: SnackPosition.TOP,
        );
        Get.to(() => Login());
      } else {
        try {
          final data = jsonDecode(response.body);
          Get.snackbar(
            "회원가입 실패",
            data['message'] ?? "알 수 없는 오류 발생",
            snackPosition: SnackPosition.TOP,
          );
        } catch (e) {
          Get.snackbar(
            "회원가입 실패",
            response.body,
            snackPosition: SnackPosition.TOP,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "네트워크 오류",
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
                  '회원가입',
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
                            hintText: "이름",
                            hintStyle: TextStyle(fontSize: 12),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          onChanged: (value) => name = value,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 323,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "전화번호",
                            hintStyle: TextStyle(fontSize: 12),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          onChanged: (value) => phone = value,
                        ),
                      ),
                      SizedBox(height: 10),
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
                          onChanged: (value) => email = value,
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
                              ),
                            ),
                          ),
                          onChanged: (value) => password = value,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 323,
                        child: Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value ?? false;
                                });
                              },
                              activeColor: Colors.white,
                              checkColor: Color(0xFF878CEF),
                            ),
                            Expanded(
                              child: Text(
                                '이용 약관, 개인정보 처리방침에 동의합니다.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: signup, // 회원가입 함수 호출
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF878CEF),
                          minimumSize: Size(352, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "회원가입",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
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
                        onTap: () {
                          // 비밀번호 찾기 로직 추가
                        },
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
                        '이미 계정이 있나요? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          '로그인',
                          style: TextStyle(
                            color: Color(0xFF878CEF),
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          Get.back();
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Get.to(HomeScreen());
                    },
                    child: Text(
                      '건너뛰기',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
