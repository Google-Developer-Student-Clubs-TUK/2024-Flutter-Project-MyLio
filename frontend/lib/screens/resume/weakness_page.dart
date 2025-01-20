import 'package:flutter/material.dart';

class WeaknessPage extends StatefulWidget {
  final List<String> initialWeaknesses; // 초기 약점 리스트를 전달받기 위한 필드

  const WeaknessPage({Key? key, required this.initialWeaknesses})
      : super(key: key);

  @override
  State<WeaknessPage> createState() => _WeaknessPageState();
}

class _WeaknessPageState extends State<WeaknessPage> {
  late List<String> weaknesses; // 약점 리스트

  @override
  void initState() {
    super.initState();
    // 초기 데이터를 복사
    weaknesses = List.from(widget.initialWeaknesses);
    // 기본 3개의 필드가 없으면 추가
    while (weaknesses.length < 3) {
      weaknesses.add("");
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
          '약점',
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
            // 빈 값 제거 후 데이터 반환
            weaknesses = weaknesses
                .where((weakness) => weakness.trim().isNotEmpty)
                .toList();
            Navigator.pop(context, weaknesses);
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
                    '약점은 최대 5개까지 입력이 가능합니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 약점 입력 필드
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: weaknesses.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildWeaknessField(index),
                    );
                  },
                ),
                // 약점 추가 버튼
                if (weaknesses.length < 5) // 최대 5개일 때 추가 버튼 숨기기
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: TextButton.icon(
                      onPressed: () {
                        if (weaknesses.length < 5) {
                          setState(() {
                            weaknesses.add(""); // 새 입력 필드 추가
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFF908CFF),
                      ),
                      label: const Text(
                        '약점 추가',
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
              onPressed: () {
                // 빈 필드를 제거하고 데이터 반환
                weaknesses = weaknesses
                    .where((weakness) => weakness.trim().isNotEmpty)
                    .toList();
                Navigator.pop(context, weaknesses);
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

  Widget _buildWeaknessField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '약점 ${index + 1}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: weaknesses[index]),
          onChanged: (value) {
            weaknesses[index] = value; // 입력 값 업데이트
          },
          decoration: InputDecoration(
            hintText: index == 0
                ? 'ex) 집중력이 좀 떨어진다'
                : index == 1
                    ? 'ex) 스트레스를 잘 받는다'
                    : index == 2
                        ? 'ex) 끝까지 일을 해내는 의지가 좀 부족하다'
                        : 'ex) 기타 약점',
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
