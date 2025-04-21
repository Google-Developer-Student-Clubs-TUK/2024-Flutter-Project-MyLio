import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const Login());
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late SharedPreferences prefs; // 향후 사용 예정
  bool _isPasswordVisible = false;

  String email = '';
  String password = '';

  //로그인
  Future<void> login() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) {
      Get.snackbar('오류', 'API_BASE_URL이 설정되지 않았습니다.',
          snackPosition: SnackPosition.TOP);
      return;
    }

    final loginUrl = Uri.parse('$baseUrl/api/v1/auth/user');

    try {
      /* 1. 최초 로그인 – 토큰이 없으므로 http 패키지로 직접 호출 */
      final res = await http.get(
        loginUrl,
        headers: {'email': email, 'pw': password},
      );

      if (res.statusCode != 200) {
        Get.snackbar('로그인 실패', res.body, snackPosition: SnackPosition.TOP);
        return;
      }

      /* 2. 쿠키에서 ACCESS_TOKEN / REFRESH_TOKEN / USER_ID 파싱 */
      final cookies = res.headers['set-cookie'];
      if (cookies == null) {
        Get.snackbar('로그인 실패', '쿠키 정보가 없습니다.',
            snackPosition: SnackPosition.TOP);
        return;
      }

      final accessToken = _extractCookieValue(cookies, 'ACCESS_TOKEN');
      final refreshToken = _extractCookieValue(cookies, 'REFRESH_TOKEN');
      final userId = _extractCookieValue(cookies, 'USER_ID');

      if ([accessToken, refreshToken, userId].contains(null)) {
        Get.snackbar('로그인 실패', '쿠키 파싱에 실패했습니다.',
            snackPosition: SnackPosition.TOP);
        return;
      }

      /* 3. SecureStorage 에 저장 → 이후 인터셉터가 자동 첨부 */
      await secureStorage.write(key: 'jwt_token', value: accessToken);
      await secureStorage.write(key: 'refresh_token', value: refreshToken);
      await secureStorage.write(key: 'user_id', value: userId);

      /* 4. 성공 UX 처리 */
      Get.snackbar('로그인 성공', '홈 화면으로 이동합니다.', snackPosition: SnackPosition.TOP);
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar('네트워크 오류', '서버에 연결할 수 없습니다.',
          snackPosition: SnackPosition.TOP);
      print('login() error ➜ $e');
    }
  }

  //쿠키 파싱 유틸 함수

  String? _extractCookieValue(String cookies, String key) {
    final reg = RegExp('$key=([^;]*);?'); // key=값; 형태 캡처
    final match = reg.firstMatch(cookies);
    return match != null ? match.group(1) : null;
  }

  // UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Spacer(),
            _buildForm(),
            const Spacer(),
            _buildBottomLinks(),
          ],
        ),
      ),
    );
  }

  /* ----------------------------- Form 파트 ------------------------------ */
  Widget _buildForm() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('로그인',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildEmailField(),
                const SizedBox(height: 10),
                _buildPasswordField(),
                const SizedBox(height: 40),
                _buildLoginButton(),
                const SizedBox(height: 15),
                const Text(
                  '비밀번호를 잊어버리셨나요?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888888),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildEmailField() => SizedBox(
        width: 323,
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: '이메일',
            hintStyle: TextStyle(fontSize: 12),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
          ),
          onChanged: (v) => email = v.trim(),
          validator: (v) => (v == null || v.isEmpty) ? '이메일을 입력하세요' : null,
        ),
      );

  Widget _buildPasswordField() => SizedBox(
        width: 323,
        child: TextFormField(
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: '비밀번호',
            hintStyle: const TextStyle(fontSize: 12),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            suffixIcon: IconButton(
              icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFFC1C7D0)),
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
          ),
          onChanged: (v) => password = v.trim(),
          validator: (v) => (v == null || v.isEmpty) ? '비밀번호를 입력하세요' : null,
        ),
      );

  Widget _buildLoginButton() => TextButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) login();
        },
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF878CEF),
          minimumSize: const Size(352, 45),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          '로그인',
          style: TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700),
        ),
      );

  /* --------------------------- 하단 링크 파트 --------------------------- */
  Widget _buildBottomLinks() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('아직 계정이 없으신가요? ',
                  style: TextStyle(fontSize: 14, color: Color(0xFFAAAAAA))),
              GestureDetector(
                onTap: () => Get.to(() => Signup()),
                child: const Text('회원가입',
                    style: TextStyle(color: Color(0xFF878CEF), fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Get.to(() => const HomeScreen()),
            child: const Text('건너뛰기',
                style: TextStyle(fontSize: 12, color: Color(0xFFCCCCCC))),
          ),
        ],
      );
}
