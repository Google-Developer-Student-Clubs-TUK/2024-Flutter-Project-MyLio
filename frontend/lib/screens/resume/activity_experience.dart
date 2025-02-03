import 'package:flutter/material.dart';

class ActivityExperience extends StatefulWidget {
  final List<Map<String, String>> initialActivities;

  const ActivityExperience({Key? key, required this.initialActivities})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ActivityExperienceState();
}

class _ActivityExperienceState extends State<ActivityExperience> {
  late List<Map<String, String>> activities;

  @override
  void initState() {
    super.initState();
    // 초기 데이터 복사
    activities = List.from(widget.initialActivities);
    if (activities.isEmpty) {
      activities.add({
        "name": "",
        "organization": "",
        "startDate": "",
        "endDate": "",
        "description": ""
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '활동/경험',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            _saveAndPop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                const Center(
                  child: Text(
                    '활동/경험은 최대 5개까지 입력이 가능합니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: buildActivityField(index),
                    );
                  },
                ),
                if (activities.length < 5)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        activities.add({
                          "name": "",
                          "organization": "",
                          "startDate": "",
                          "endDate": "",
                          "description": ""
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xFF908CFF),
                    ),
                    label: const Text(
                      '활동/경험 추가',
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveAndPop,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF908CFF),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '입력완료',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DatePicker 호출 함수
  Future<void> _selectDate(
      BuildContext context, int index, String dateKey) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        activities[index][dateKey] =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Widget buildActivityField(int index) {
    return Column(
      key: ValueKey(index),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  activities[index]["name"] = value;
                },
                controller: TextEditingController(
                  text: activities[index]["name"],
                ),
                decoration: InputDecoration(
                  hintText: '활동명',
                  hintStyle: const TextStyle(color: Colors.black38),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                setState(() {
                  activities.removeAt(index);
                });
              },
              icon: const Icon(Icons.close, color: Colors.black38),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) {
            activities[index]["organization"] = value;
          },
          controller: TextEditingController(
            text: activities[index]["organization"],
          ),
          decoration: InputDecoration(
            hintText: '기관/장소',
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context, index, 'startDate'),
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: "시작 날짜",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    activities[index]['startDate']?.isNotEmpty == true
                        ? activities[index]['startDate']!
                        : "시작 날짜",
                    style: TextStyle(
                      color: activities[index]['startDate']?.isNotEmpty == true
                          ? Colors.black
                          : Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text("~"),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context, index, 'endDate'),
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: "종료 날짜",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    activities[index]['endDate']?.isNotEmpty == true
                        ? activities[index]['endDate']!
                        : "종료 날짜",
                    style: TextStyle(
                      color: activities[index]['endDate']?.isNotEmpty == true
                          ? Colors.black
                          : Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) {
            activities[index]["description"] = value;
          },
          controller: TextEditingController(
            text: activities[index]["description"],
          ),
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '활동 내용을 입력해주세요.',
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _saveAndPop() {
    Navigator.pop(context, activities);
  }
}
