import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool _isPasswordVisible = false;

  late String email = '';
  late String password = '';

  Future<void> login() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      Get.snackbar("오류", "API_BASE_URL 환경 변수가 설정되지 않았습니다.", snackPosition: SnackPosition.TOP);
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
            await secureStorage.write(key: "jwt_token", value: jwtToken);
            print("JWT 저장 완료: $jwtToken");

            Get.snackbar("로그인 성공", "홈 화면으로 이동합니다.", snackPosition: SnackPosition.TOP);
            Get.to(() => HomeScreen());
            return;
          }
        }

        Get.snackbar("로그인 실패", "JWT 토큰을 찾을 수 없습니다.", snackPosition: SnackPosition.TOP);
      } else {
        Get.snackbar("로그인 실패", '로그인에 실패하였습니다: ${response.body}', snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar("네트워크 에러", "서버와 연결할 수 없습니다.", snackPosition: SnackPosition.TOP);
      print('문제 : $e');
    }
  }

  String? _extractJwtFromCookie(String cookie) {
    List<String> cookies = cookie.split("; ");
    for (String c in cookies) {
      if (c.startsWith("ACCESS_TOKEN=")) {
        String token = c.split("=")[1]; // JWT + REFRESH_TOKEN 포함 가능
        if (token.contains(",")) {
          token = token.split(",")[0]; // ✅ 첫 번째 값(JWT)만 저장
        }
        return token;
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
            Text(
              '로그인',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(hintText: "이메일"),
                    onChanged: (value) => email = value,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "비밀번호",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    onChanged: (value) => password = value,
                  ),
                  SizedBox(height: 40),
                  TextButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        login();
                      }
                    },
                    child: Text("로그인"),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}