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
      "name": "",
      "organization": "",
      "startDate": "",
      "endDate": "",
      "description": ""
    };
  }

  // DatePicker 호출 함수
  Future<void> _selectDate(
      BuildContext context, int fieldKey, String dateKey) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        activityData[fieldKey]?[dateKey] =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
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
                  activityData[number]?['name'] = value;
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
                        const BorderSide(color: Color(0xFF908CFF), width: 1.0),
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
              activityData[number]?['organization'] = value;
            },
            decoration: InputDecoration(
              hintText: "기관/장소",
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFF908CFF), width: 1.0),
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
            GestureDetector(
              onTap: () => _selectDate(context, number, 'startDate'),
              child: Container(
                width: 168,
                height: 47,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFCCCCCC), width: 1.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activityData[number]?['startDate']?.isNotEmpty == true
                          ? activityData[number]!['startDate']!
                          : "시작 날짜",
                      style: TextStyle(
                        fontSize: 14,
                        color: activityData[number]?['startDate']?.isNotEmpty ==
                                true
                            ? Colors.black
                            : Color(0xFFCCCCCC),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFFCCCCCC),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5),
            Text("~"),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () => _selectDate(context, number, 'endDate'),
              child: Container(
                width: 168,
                height: 47,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFCCCCCC), width: 1.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activityData[number]?['endDate']?.isNotEmpty == true
                          ? activityData[number]!['endDate']!
                          : "종료 날짜",
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            activityData[number]?['endDate']?.isNotEmpty == true
                                ? Colors.black
                                : Color(0xFFCCCCCC),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFFCCCCCC),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            onChanged: (value) {
              activityData[number]?['description'] = value;
            },
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: activityData[number]?['description'] ?? "",
                selection: TextSelection.collapsed(
                    offset: activityData[number]?['description']?.length ?? 0),
              ),
            ),
            maxLines: 3, // 최대 3줄 입력 가능
            decoration: InputDecoration(
              hintText: '활동 내용을 입력해주세요.',
              hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFF908CFF), width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
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
                          child: TextButton.icon(
                            onPressed: () {
                              if (fieldKeys.length < 5) {
                                setState(() {
                                  num++;
                                  fieldKeys.add(num);
                                  activityData[num] = {
                                    "name": "",
                                    "organization": "",
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
                            icon: const Icon(
                              Icons.add,
                              color: Color(0xFF908CFF),
                            ),
                            label: const Text(
                              '경험 추가',
                              style: TextStyle(
                                color: Color(0xFF908CFF),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              side: const BorderSide(
                                color: Color(0xFF908CFF),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
