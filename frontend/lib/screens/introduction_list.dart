
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widgets/bottom_bar.dart';
import 'app_colors.dart';


class IntroductionList extends StatelessWidget {
  const IntroductionList({super.key});

  @override
  Widget build(BuildContext context) {
    // 리스트 항목 데이터
    final resumes = [
      '[GDSC] 웹 개발자 (체험형 인턴)',
      '[GDSC] AI 엔지니어 (정규직)',
      '[GDSC] 프로젝트 매니저 (인턴)',

    ];

    return Scaffold(

      // 앱바
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
            Navigator.pop(context); // 이전 화면으로 이동
          },
        ),
      ),

      // ai 자기소개서 리스트 builder
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: resumes.length,
        itemBuilder: (context, index) {
          return Container(

            // 각 리스트 박스 디자인
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

            // 각 리스트 박스 내 자기소개서 제목
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 텍스트
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


                // 옵션 팝업 메뉴
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {

                    // 옵션: 미리보기 다이얼로그
                    if (value == 'preview'){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: 353,
                                height: double.infinity,
                              ),

                            );
                          }


                      );

                    }

                    // 옵션: 삭제하기 다이얼로그
                    else if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              height: 228,
                              width: 353,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${resumes[index]}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 30
                                    ),

                                    const Text(
                                      '정말 삭제하시겠습니까?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 30,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColor.color2,
                                            foregroundColor: Colors.white,
                                            minimumSize: Size(100, 44),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            // 삭제 처리 로직
                                            print('Item Deleted');
                                            Navigator.of(context).pop(); // 다이얼로그 닫기
                                          },
                                          child: const Text('예',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 20,
                                        ),

                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              // foregroundColor: Colors.black26,
                                              minimumSize: Size(100, 44),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  side: const BorderSide(
                                                      color: AppColor.color2
                                                  )
                                              ),

                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop(); // 다이얼로그 닫기
                                            },
                                            child: const Text('아니요',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.color2,
                                              ),
                                            )
                                        ),

                                      ],
                                    ),
                                  ]
                              ),
                            ),
                          );

                        },
                      );
                    }



                    else {
                      print('Selected: $value for ${resumes[index]}');
                    }
                  },

                  // 옵션 팝업메뉴 항목
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                          value: 'preview',
                          child: Center(
                            child: Text('미리보기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12
                              ),
                            ),
                          )
                      ),
                      const PopupMenuItem(
                          value: 'modify',
                          child: Center(
                            child: Text('수정하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12
                              ),
                            ),
                          )
                      ),
                      const PopupMenuItem(
                          value: 'delete',
                          child: Center(
                            child: Text('삭제하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12
                              ),
                            ),
                          )
                      ),
                      const PopupMenuItem(
                          value: 'copy',
                          child: Center(
                              child: Text('복사하기',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12
                                ),
                              )
                          )
                      ),
                    ];
                  },
                  // 여기에 선택에 따른 동작 추가
                )
              ],
            ),
          );
        },
      ),

      floatingActionButton: Container(
        height: 70.0,
        width: 70.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Gradients.blue, Gradients.purple, Gradients.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            // 새로운 자기소개서 추가 화면으로 이동
            print('Add new resume');
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.add, size: 41, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBar(
        onGridPressed: () {
          Navigator.pop(context); // 이전 화면으로 이동
        },
        onSettingsPressed: () {
          // 설정 화면으로 이동
          print('Settings pressed');
        },
        onFabPressed: () {
          // FAB 버튼 동작
          print('FAB pressed');
        },
      ),

    );
  }
}



