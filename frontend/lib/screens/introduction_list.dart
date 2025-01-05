import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'app_colors.dart';
import 'widgets/bottom_bar.dart';

class IntroductionList extends StatefulWidget {
  final List<Map<String, dynamic>> initialData; // 초기 데이터 추가

  // 생성자에 초기 데이터 추가
  IntroductionList({Key? key, this.initialData = const []}) : super(key: key);

  @override
  State<IntroductionList> createState() => _IntroductionListState();
}

class _IntroductionListState extends State<IntroductionList> {
  List<String> resumes = [
    '[GDSC] 웹 개발자 (체험형 인턴)',
    '[GDSC] AI 엔지니어 (정규직)',
    '[GDSC] 프로젝트 매니저 (인턴)',
  ];

  List<Map<String, dynamic>> introductions = [];

  @override
  void initState() {
    super.initState();
    introductions = widget.initialData; // 초기 데이터 적용
  }

  @override
  Widget build(BuildContext context) {
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
        itemCount: introductions.length,
        itemBuilder: (context, index) {
          final intro = introductions[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            width: MediaQuery.of(context).size.width * 0.9,
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff8978EB), Color(0xffDAD8FF)],
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
                  child: Column(
                    children: [
                      Text(
                        '${intro['title']}\n${intro['company']}-${intro['jobTitle']}',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),


                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'preview'){
                      _showPreviewDialog(context, index);
                    }

                    else if (value == 'delete') {
                      _showDeleteDialog(context, index);
                    }
                  },


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
                              )
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
                        ),
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
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPreviewDialog(BuildContext context, int index){
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      '${introductions[index]['title']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                  ),
                  Text(
                      '${introductions[index]['company']}-${introductions[index]['jobTitle']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${introductions[index]['questions']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${introductions[index]['answers']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
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
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${introductions[index]['title']}',
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
                          setState(() {
                            introductions.removeAt(index);
                          });
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
}


