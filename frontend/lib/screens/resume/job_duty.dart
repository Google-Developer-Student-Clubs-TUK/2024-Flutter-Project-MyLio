import 'package:flutter/material.dart';

class Job_Duty extends StatefulWidget {
  final String initialJobDuty; // 초기 직무 데이터

  const Job_Duty({Key? key, required this.initialJobDuty}) : super(key: key);

  @override
  State<Job_Duty> createState() => _Job_DutyState();
}

class _Job_DutyState extends State<Job_Duty> {
  late TextEditingController _jobDutyController;

  @override
  void initState() {
    super.initState();
    // 초기값이 null이면 빈 문자열로 처리하여 예외 방지
    _jobDutyController =
        TextEditingController(text: widget.initialJobDuty ?? '');
  }

  @override
  void dispose() {
    _jobDutyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '직무',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                '직무를 입력해주세요.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '직무',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 352,
                    height: 47,
                    child: TextFormField(
                      controller: _jobDutyController,
                      decoration: InputDecoration(
                        hintText: "ex) 서비스 기획",
                        hintStyle: const TextStyle(
                            fontSize: 14, color: Color(0xFFCCCCCC)),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFFCCCCCC), width: 1.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFFCCCCCC), width: 1.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFF908CFF), width: 1.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  // 빈 값이 아닌 경우에만 반환
                  String updatedJobDuty = _jobDutyController.text.trim();
                  if (updatedJobDuty.isNotEmpty) {
                    Navigator.pop(context, updatedJobDuty);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('직무를 입력해주세요.')),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF878CEF),
                  minimumSize: const Size(352, 47),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "입력완료",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
