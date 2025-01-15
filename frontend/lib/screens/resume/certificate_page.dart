import 'package:flutter/material.dart';

class CertificatePage extends StatefulWidget {
  final List<Map<String, String>> initialCertificates;

  const CertificatePage({Key? key, required this.initialCertificates})
      : super(key: key);

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  // 자격증 리스트
  late List<Map<String, String>> certificates;

  @override
  void initState() {
    super.initState();
    // 초기 데이터 복사
    certificates = List.from(widget.initialCertificates);
    if (certificates.isEmpty) {
      certificates.add({"name": "", "date": "", "issuer": ""});
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
          '자격증',
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
            Navigator.pop(context, certificates);
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
                    '해당 직무와 관련이 높은 자격증을 입력해주세요.\n최대 5개까지 입력이 가능합니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 자격증 입력 필드
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: certificates.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _buildCertificateField(index),
                    );
                  },
                ),
                // 자격증 추가 버튼
                if (certificates.length < 5)
                  TextButton.icon(
                    onPressed: () {
                      if (certificates.length < 5) {
                        setState(() {
                          certificates.add({
                            "name": "",
                            "date": "",
                            "issuer": ""
                          }); // 새 필드 추가
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xFF908CFF),
                    ),
                    label: const Text(
                      '자격증 추가',
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
                Navigator.pop(context, certificates);
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

  Widget _buildCertificateField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 자격증명 입력 필드
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  certificates[index]["name"] = value;
                },
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: certificates[index]["name"]!,
                    selection: TextSelection.collapsed(
                        offset: certificates[index]["name"]!.length),
                  ),
                ),
                decoration: InputDecoration(
                  hintText: '자격증명',
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
            // 삭제 버튼
            IconButton(
              onPressed: () {
                setState(() {
                  certificates.removeAt(index);
                });
              },
              icon: const Icon(Icons.close, color: Colors.black38),
            ),
          ],
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
                certificates[index]["date"] =
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
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  certificates[index]["date"]!.isEmpty
                      ? '취득 연도 ex) 24.01.01'
                      : certificates[index]["date"]!,
                  style: TextStyle(
                    color: certificates[index]["date"]!.isEmpty
                        ? Colors.black38
                        : Colors.black87,
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
        const SizedBox(height: 16),

        // 발행처 입력 필드
        TextField(
          onChanged: (value) {
            certificates[index]["issuer"] = value;
          },
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: certificates[index]["issuer"]!,
              selection: TextSelection.collapsed(
                  offset: certificates[index]["issuer"]!.length),
            ),
          ),
          decoration: InputDecoration(
            hintText: '발행처',
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
      ],
    );
  }
}
