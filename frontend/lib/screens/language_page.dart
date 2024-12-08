import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  // 어학 리스트
  List<Map<String, String>> languages = [
    {"language": "", "exam": "", "score": "", "date": ""}
  ]; // 기본 1개의 입력 필드

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
            Navigator.pop(context);
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
                // 어학 입력 필드
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
                // 어학 추가 버튼
                if (languages.length < 10)
                  TextButton.icon(
                    onPressed: () {
                      if (languages.length < 10) {
                        setState(() {
                          languages.add({
                            "language": "",
                            "exam": "",
                            "score": "",
                            "date": ""
                          }); // 새 필드 추가
                        });
                      }
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
          // 입력 완료 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print('입력 완료: $languages');
              },
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
        // 언어 입력 필드
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  languages[index]["language"] = value;
                },
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF908CFF)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 삭제 버튼
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
        // 시험명 입력 필드
        TextField(
          onChanged: (value) {
            languages[index]["exam"] = value;
          },
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
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF908CFF)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 점수/급수 입력 필드
        TextField(
          onChanged: (value) {
            languages[index]["score"] = value;
          },
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
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF908CFF)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 취득 연도 DatePicker 필드
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
              hintText: '취득 연도 ex) 24.01.01',
              hintStyle: const TextStyle(color: Colors.black38),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF908CFF)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languages[index]["date"]!.isEmpty
                      ? '취득 연도 ex) 24.01.01'
                      : languages[index]["date"]!,
                  style: TextStyle(
                    color: languages[index]["date"]!.isEmpty
                        ? Colors.black38
                        : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black38,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
