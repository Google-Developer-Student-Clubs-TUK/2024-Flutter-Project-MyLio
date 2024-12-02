import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'app_colors.dart';

class QuestionInsert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: const Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '자기소개서 문항 입력',
                    style: TextStyle(
                      fontSize: 29,
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    '자기소개서 문항은 최대 3개까지 입력이 가능하며,\n1000자 이내로 답변을 해줍니다.',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    '자기소개서 제목',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 6),
                  TextField(
                    decoration: InputDecoration(
                        labelText: '제목을 입력해 주세요.',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '자기소개서 문항 1',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 6),
                  TextField(
                    decoration: InputDecoration(
                        labelText: '문항을 입력해주세요.',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '자기소개서 문항 2',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 6),
                  TextField(
                    decoration: InputDecoration(
                        labelText: '문항을 입력해주세요.',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '자기소개서 문항 3',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 3),
                  TextField(
                    decoration: InputDecoration(
                        labelText: '문항을 입력해주세요.',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  )
                ],
              ),
            ],
          )),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          width: 352,
          height: 47,
          decoration: BoxDecoration(
            color: AppColor.main,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              '입력 완료',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
