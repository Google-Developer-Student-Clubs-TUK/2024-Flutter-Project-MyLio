import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(ActivityExperience());
}

class ActivityExperience extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ActivityExperienceState();
  }
}

class ActivityExperienceState extends State<ActivityExperience> {
  int num = 1;
  List<int> fieldKeys = [];
  Map<int, Map<String, String>> activityData = {}; // 활동 데이터 저장

  @override
  void initState() {
    super.initState();
    fieldKeys.add(num);
    activityData[num] = {
      "activityName": "",
      "institution": "",
      "startDate": "",
      "endDate": "",
      "description": ""
    };
  }

  // 활동 필드 생성 함수
  Widget buildActivityField(int number) {
    return Column(
      key: ValueKey(number),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 47,
              child: TextFormField(
                onChanged: (value) {
                  activityData[number]?['activityName'] = value;
                },
                decoration: InputDecoration(
                  hintText: "활동명",
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    fieldKeys.remove(number);
                    activityData.remove(number);
                  });
                },
                icon: FaIcon(
                  FontAwesomeIcons.xmark,
                  color: Color(0xFFCCCCCC),
                ))
          ],
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 352,
          height: 47,
          child: TextFormField(
            onChanged: (value) {
              activityData[number]?['institution'] = value;
            },
            decoration: InputDecoration(
              hintText: "기관/장소",
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 168,
              height: 47,
              child: TextFormField(
                onChanged: (value) {
                  activityData[number]?['startDate'] = value;
                },
                decoration: InputDecoration(
                  hintText: "ex) 24.03",
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Text("~"),
            SizedBox(width: 5),
            SizedBox(
              width: 168,
              height: 47,
              child: TextFormField(
                onChanged: (value) {
                  activityData[number]?['endDate'] = value;
                },
                decoration: InputDecoration(
                  hintText: "ex) 24.11",
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 352,
          height: 100,
          child: TextFormField(
            onChanged: (value) {
              activityData[number]?['description'] = value;
            },
            maxLines: null,
            expands: true,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              hintText: "활동 내용을 입력해주세요.",
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '활동/경험',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      '활동/경험을 입력해주세요.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...fieldKeys
                            .map((key) => buildActivityField(key))
                            .toList(),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 352,
                          height: 47,
                          child: TextButton(
                            onPressed: () {
                              if (fieldKeys.length < 5) {
                                setState(() {
                                  num++;
                                  fieldKeys.add(num);
                                  activityData[num] = {
                                    "activityName": "",
                                    "institution": "",
                                    "startDate": "",
                                    "endDate": "",
                                    "description": ""
                                  };
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("경험 최대 5개까지만 추가할 수 있습니다."),
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
                                SizedBox(width: 10),
                                Text(
                                  '경험 추가',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            style: TextButton.styleFrom(
                              side: BorderSide(
                                color: Color(0xFF908CFF),
                                width: 1.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context, activityData.values.toList());
                },
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
          ),
        ],
      ),
    );
  }
}
