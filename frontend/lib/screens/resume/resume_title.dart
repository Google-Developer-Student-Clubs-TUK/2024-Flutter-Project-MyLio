import 'package:flutter/material.dart';

class Resume_Title extends StatefulWidget {
  final String initialTitle; // 이력서 제목 초기값 전달받기

  const Resume_Title(
      {Key? key, required this.initialTitle, required String title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return Resume_Title_State();
  }
}

class Resume_Title_State extends State<Resume_Title> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialTitle); // 초기값 설정
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '이력서 제목',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                '이력서 제목을 입력해주세요.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '이력서 제목',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 352,
                    height: 47,
                    child: TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: "ex) 서비스 기획자 이력서",
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
                  Navigator.pop(context, _titleController.text); // 데이터 반환
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
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
