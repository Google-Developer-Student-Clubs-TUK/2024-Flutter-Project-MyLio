import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/screens/edit.dart';
import 'package:frontend/screens/my_resume_create_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(Add_Resume());
}

class Add_Resume extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Add_Resume_State();
  }
}

class Add_Resume_State extends State<Add_Resume> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'My 이력서',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 15, bottom: 15),
                width: 352,
                height: 92,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(251, 251, 251, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 57.31,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(144, 140, 255, 1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            '대표 이력서',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton(
                          color: Colors.white,
                          elevation: 1,
                          offset: const Offset(0, 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          itemBuilder: (context) {
                            return <PopupMenuEntry<dynamic>>[
                              PopupMenuItem(
                                child: const Center(
                                  child: Text(
                                    '대표이력서 설정',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                onTap: () {},
                              ),
                              const PopupMenuDivider(
                                height: 5,
                              ),
                              PopupMenuItem(
                                child: const Center(
                                  child: Text('수정하기',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                                ),
                                onTap: () {
                                  Get.to(Edit());
                                },
                              ),
                              const PopupMenuDivider(
                                height: 5,
                              ),
                              PopupMenuItem(
                                child: const Center(
                                  child: Text('삭제하기',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                                ),
                                onTap: () {},
                              ),
                              const PopupMenuDivider(
                                height: 5,
                              ),
                              PopupMenuItem(
                                child: const Center(
                                  child: Text('복사하기',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                                ),
                                onTap: () {},
                              )
                            ];
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.ellipsisVertical,
                            size: 15,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "서비스 기획자 이력서",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(MyResumeCreatePage());
                },
                child: DottedBorder(
                  color: Colors.grey, // 점선 색상
                  strokeWidth: 1, // 점선 두께
                  dashPattern: [2, 2], // 점선 패턴
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12), // 둥근 테두리
                  child: Container(
                    width: 352,
                    height: 47,
                    alignment: Alignment.center,
                    child: const Text(
                      '+ 이력서 추가',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
