import 'package:flutter/material.dart';

class StrengthPage extends StatefulWidget {
  final List<String> initialStrengths; // 초기 강점 리스트를 전달받기 위한 필드

  const StrengthPage({Key? key, required this.initialStrengths})
      : super(key: key);

  @override
  State<StrengthPage> createState() => _StrengthPageState();
}

class _StrengthPageState extends State<StrengthPage> {
  late List<String> strengths; // 강점 리스트

  @override
  void initState() {
    super.initState();
    strengths = List.from(widget.initialStrengths); // 전달받은 강점 리스트 복사
    // 전달받은 리스트가 3개 미만이면 기본값 추가
    while (strengths.length < 3) {
      strengths.add("");
    }
  }

  void _handleReturn() {
    // 빈 문자열 제거 후 반환
    final filteredStrengths =
        strengths.where((strength) => strength.trim().isNotEmpty).toList();
    Navigator.pop(context, filteredStrengths); // 필터링된 강점 리스트 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '강점',
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
          onPressed: _handleReturn, // 뒤로가기 시 강점 리스트 반환
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
                    '강점은 최대 5개까지 입력이 가능합니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 강점 입력 필드
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: strengths.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildStrengthField(index),
                    );
                  },
                ),
                // 강점 추가 버튼
                if (strengths.length < 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: TextButton.icon(
                      onPressed: () {
                        if (strengths.length < 5) {
                          setState(() {
                            strengths.add(""); // 새 입력 필드 추가
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFF908CFF),
                      ),
                      label: const Text(
                        '강점 추가',
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
          // 입력 완료 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _handleReturn,
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

  Widget _buildStrengthField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '강점 ${index + 1}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: strengths[index]),
          onChanged: (value) {
            strengths[index] = value; // 입력 값 업데이트
          },
          decoration: InputDecoration(
            hintText: index == 0
                ? 'ex) 꼼꼼하다'
                : index == 1
                    ? 'ex) 리더십이 있다'
                    : index == 2
                        ? 'ex) 도전 의지가 강하다'
                        : 'ex) 기타 강점',
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
      ],
    );
  }
}
