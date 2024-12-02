import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(Activity_Experience());
}

class Activity_Experience extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Activity_Experience_State();
  }
}

class Activity_Experience_State extends State<Activity_Experience> {
  int num = 1; // 초기 산업군 번호
  List<Widget> industryFields = []; // 산업군 필드를 저장하는 리스트

  @override
  void initState() {
    super.initState();
    industryFields.add(buildIndustryField(1)); // 초기 산업군 필드 추가
  }

  // 산업군 필드 생성 함수
  Widget buildIndustryField(int number) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '산업군$number',
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
              hintText: "ex) 헬스케어, 금융, 패션, 영화, 교육",
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                borderRadius: BorderRadius.circular(12.0), // 테두리 둥글게
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '산업군',
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
                '산업군은 최대 3개까지 입력이 가능합니다.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...industryFields, // 산업군 필드 리스트 추가
                    SizedBox(
                      width: 352,
                      height: 47,
                      child: TextButton(
                        onPressed: () {
                          // 산업군 추가 버튼 눌렀을 때 동작
                          if (industryFields.length < 3) {
                            setState(() {
                              num++;
                              industryFields.add(buildIndustryField(num));
                            });
                          } else {
                            // 최대 3개 안내 메시지
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("산업군은 최대 3개까지만 추가할 수 있습니다."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.plus,
                              size: 12,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '산업군 추가',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        style: TextButton.styleFrom(
                          side: BorderSide(
                              color: Color(0xFF908CFF), width: 1.0), // 테두리 설정
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12.0), // 모서리 둥글게 설정
                          ),
                        ),
                      ),
                    )
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