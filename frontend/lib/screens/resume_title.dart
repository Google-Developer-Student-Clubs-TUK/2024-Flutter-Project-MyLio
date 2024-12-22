import 'package:flutter/material.dart';

void main() {
  runApp(Resume_Title());
}

class Resume_Title extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Resume_Title_State();
  }
}

class Resume_Title_State extends State<Resume_Title> {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '이력서 제목',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(16.0), // 여백 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Center(
                child: Text(
                  '이력서 제목을 입력해주세요.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이력서 제목',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 352,
                        height: 47,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "ex) 서비스 기획자 이력서",
                            hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
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
                    "입력완료",
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