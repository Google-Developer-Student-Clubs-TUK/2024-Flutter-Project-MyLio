import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  final List<Map<String, String>> initialLanguages;

  const LanguagePage({Key? key, required this.initialLanguages})
      : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  // 어학 리스트
  late List<Map<String, String>> languages;

  @override
  void initState() {
    super.initState();
    // 초기 데이터 복사
    languages = List.from(widget.initialLanguages);
    if (languages.isEmpty) {
      languages.add({"language": "", "exam": "", "score": "", "date": ""});
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
          '어학',
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
                    '어학은 최대 10개까지 입력이 가능합니다.',
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
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: _buildLanguageField(index),
                    );
                  },
                ),
                if (languages.length < 10)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        languages.add({
                          "language": "",
                          "exam": "",
                          "score": "",
                          "date": ""
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xFF908CFF),
                    ),
                    label: const Text(
                      '어학 추가',
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

  Widget _buildLanguageField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  languages[index]["language"] = value;
                },
                controller: TextEditingController(
                  text: languages[index]["language"],
                ),
                decoration: InputDecoration(
                  hintText: '언어',
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
                  languages.removeAt(index);
                });
              },
              icon: const Icon(Icons.close, color: Colors.black38),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) {
            languages[index]["exam"] = value;
          },
          controller: TextEditingController(
            text: languages[index]["exam"],
          ),
          decoration: InputDecoration(
            hintText: '시험명',
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
        TextField(
          onChanged: (value) {
            languages[index]["score"] = value;
          },
          controller: TextEditingController(
            text: languages[index]["score"],
          ),
          decoration: InputDecoration(
            hintText: '점수/급수',
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
        GestureDetector(
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (selectedDate != null) {
              setState(() {
                languages[index]["date"] =
                    "${selectedDate.year}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.day.toString().padLeft(2, '0')}";
              });
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: '취득 연도',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languages[index]["date"]?.isNotEmpty == true
                      ? languages[index]["date"]!
                      : '취득 연도 입력',
                  style: TextStyle(
                    color: languages[index]["date"]?.isNotEmpty == true
                        ? Colors.black
                        : Colors.black38,
                  ),
                ),
                const Icon(Icons.calendar_today_outlined,
                    color: Colors.black38),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _saveAndPop() {
    Navigator.pop(context, languages);
  }
}
