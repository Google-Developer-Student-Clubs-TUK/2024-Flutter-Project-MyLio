import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'Login.dart';

void main() async {
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
  late SharedPreferences sharedPreferences;
  bool logincheck = false;
  bool isChecked = false; // 체크박스 상태 관리
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(), // 위쪽 공간 확보
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

                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 323,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "아이디 또는 이메일",
                              hintStyle: TextStyle(fontSize: 12),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),

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
                                  onPressed: (){
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, 
                                  color: Color(0xFFC1C7D0),)
                              )
                            ),

                          ),
                        ),
                        // 체크박스
                        SizedBox(
                          height: 20,
                        ),
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
                                    borderRadius: BorderRadius.circular(50)
                                ),

                                value: isChecked,
                                onChanged: (bool? value){
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                                activeColor: Colors.white,
                                checkColor: Color(0xFF878CEF),
                              ),
                              Expanded(
                                  child: Text('이용 약관, 개인정보 처리방침에 동의합니다.',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),))
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
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
              Spacer(), // 아래쪽 공간 확보
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
                              style: TextStyle(color: Color(0xFF878CEF),
                                  fontSize: 14),
                            ),
                            onTap: (){
                              Get.to(Login());
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: Text('건너뛰기',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFCCCCCC)
                          ),),
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}