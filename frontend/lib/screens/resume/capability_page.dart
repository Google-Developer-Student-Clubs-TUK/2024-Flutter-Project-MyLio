import 'package:flutter/material.dart';

class CapabilityPage extends StatefulWidget {
  final List<String> initialCapabilities;

  const CapabilityPage({Key? key, required this.initialCapabilities})
      : super(key: key);

  @override
  State<CapabilityPage> createState() => _CapabilityPageState();
}

class _CapabilityPageState extends State<CapabilityPage> {
  late List<String> capabilities;

  @override
  void initState() {
    super.initState();
    // 초기 데이터 복사
    capabilities = List.from(widget.initialCapabilities);
    // 기본 3개의 필드가 없으면 추가
    while (capabilities.length < 3) {
      capabilities.add("");
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
          '역량',
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
            capabilities =
                capabilities.where((cap) => cap.trim().isNotEmpty).toList();
            Navigator.pop(context, capabilities);
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
                    '역량은 최대 5개까지 입력이 가능합니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 역량 입력 필드
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: capabilities.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCapabilityField(index),
                    );
                  },
                ),
                // 역량 추가 버튼
                if (capabilities.length < 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: TextButton.icon(
                      onPressed: () {
                        if (capabilities.length < 5) {
                          setState(() {
                            capabilities.add(""); // 새로운 필드 추가
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFF908CFF),
                      ),
                      label: const Text(
                        '역량 추가',
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
                            color: Color(0xFF908CFF), width: 1),
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
                capabilities =
                    capabilities.where((cap) => cap.trim().isNotEmpty).toList();
                Navigator.pop(context, capabilities);
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

  Widget _buildCapabilityField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '역량 ${index + 1}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: capabilities[index]),
          onChanged: (value) {
            capabilities[index] = value; // 입력 값 업데이트
          },
          decoration: InputDecoration(
            hintText: index == 0
                ? 'ex) 사업 기획 능력'
                : index == 1
                    ? 'ex) 시장 분석 능력'
                    : index == 2
                        ? 'ex) 비즈니스 능력'
                        : 'ex) 기타 능력',
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
