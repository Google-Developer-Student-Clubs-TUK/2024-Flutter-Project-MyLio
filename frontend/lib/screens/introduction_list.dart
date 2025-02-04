import 'package:flutter/material.dart';
import 'package:frontend/screens/components/introduction_list_PopupMeun_Btn.dart';

class IntroductionList extends StatelessWidget {
  const IntroductionList({super.key});

  @override
  Widget build(BuildContext context) {
    final resumes = [
      '[GDSC] 웹 개발자 (체험형 인턴)',
      '[GDSC] AI 엔지니어 (정규직)',
      '[GDSC] 프로젝트 매니저 (인턴)',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '자기소개서 목록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: resumes.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            width: MediaQuery.of(context).size.width * 0.9,
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff8978EB),
                  Color(0xffDAD8FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    resumes[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                // 📌 팝업 메뉴 버튼 사용
                IntroductionListPopupMenuBtn(
                  resumeTitle: resumes[index],
                  onModifyPressed: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
