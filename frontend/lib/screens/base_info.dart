import 'package:flutter/material.dart';

void main() {
  runApp(Base_Info());
}

class Base_Info extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Base_Info_State();
  }
}

class Base_Info_State extends State<Base_Info> {
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
          padding: EdgeInsets.all(16.0), // 여백 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이름',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 352,
                        height: 47,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "전서진",
                            hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC), fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0), // 테두리 둥글게
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 2.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '전화번호',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 352,
                        height: 47,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "010-1234-5678",
                            hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC), fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0), // 테두리 둥글게
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 2.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '이메일',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 352,
                        height: 47,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "gij0321@gmail.com",
                            hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC), fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0), // 테두리 둥글게
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 2.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '비밀번호',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 352,
                        height: 47,
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "****",
                            hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC), fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0), // 테두리 둥글게
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 2.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '비밀번호 확인',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 352,
                        height: 47,
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "****",
                            hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC), fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0), // 테두리 둥글게
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 2.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Center(
                child: TextButton(
                  onPressed: () {},
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
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
    );
  }
}