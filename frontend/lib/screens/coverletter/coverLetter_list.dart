
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/screens/components/coverLetter_PopupMenu_Btn.dart';

import '../theme/app_colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/bottom_bar.dart';
import 'modify_coverLetter.dart';

class CoverLetterList extends StatefulWidget {
  // final List<Map<String, dynamic>> introductions;
  //
  // const IntroductionList({Key? key, required this.introductions}) : super(key: key);
  const CoverLetterList({Key? key}) : super(key:key);

  @override
  _CoverLetterListState createState() => _CoverLetterListState();
}

class _CoverLetterListState extends State<CoverLetterList> {
  List<Map<String, dynamic>> _introductions = [];
  bool _isLoading = true;
  String? _errorMessage;
  final userId = "1";

  get updatedIntroduction => null;



  /*
  @override
  void initState() {
    super.initState();
    _introductions = List.from(widget.introductions); // 원본 리스트 복사
  }

   */
  @override
  void initState() {
    super.initState();
    _fetchIntroductions(); // 서버에서 데이터 가져오기
  }

  // 서버에서 데이터 가져오기
  Future<void> _fetchIntroductions() async {
    try {
      final url = Uri.parse('');
      final response = await http.get(url, headers: {
        'Authorization': '',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          _introductions = data.map((item) => Map<String, dynamic>.from(item)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load introductions: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }




  void _previewIntroduction(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final introduction = _introductions[index];
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16,),
                  // 제목
                  Text(
                    introduction['title'] ?? '제목 없음',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 회사명
                  Text(
                    '회사: ${introduction['company'] ?? '회사 없음'}, 직무: ${introduction['jobTitle'] ?? '직무 없음'}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),



                  // 질문 및 답변 리스트
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (introduction['questions'] as List<String>).length,
                    itemBuilder: (context, questionIndex) {
                      final question = introduction['questions'][questionIndex];
                      final answer = introduction['answers'][questionIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 질문
                          Text(
                            '${questionIndex + 1}: $question',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // 답변
                          Text(
                            '\t $answer',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),

                  // 닫기 버튼
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.color2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '닫기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

  }

  void _deleteIntroduction(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('${_introductions[index]['title']}을(를) 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _introductions.removeAt(index); // 리스트에서 항목 삭제
                });
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('아니요'),
            ),
          ],
        );
      },
    );
  }

  void _copyIntroduction(int index) {
    setState(() {
      final copied = Map<String, dynamic>.from(_introductions[index]);
      copied['title'] = '${copied['title']} (복사)';
      _introductions.add(copied);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_introductions[index]['title']}이(가) 복사되었습니다.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _modifyIntroduction(int index) async {
    final introduction = _introductions[index];

    final updateIntroduction = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifyCoverletter(
              // introduction: introduction
          ),
        )
    );

    if (updatedIntroduction != null) {
      setState(() {
        _introductions[index] = updatedIntroduction; // 수정된 데이터로 업데이트
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('수정이 완료되었습니다.')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    // introductions가 비어있을 때 처리
    if (_introductions.isEmpty) {
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
        ),
        body: const Center(
          child: Text(
            '등록된 자기소개서가 없습니다.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

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
        itemCount: _introductions.length,
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
                    '${_introductions[index]['title']}, (${_introductions[index]['company']})',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                IntroductionPopupMenu(
                    onPreview: () => _previewIntroduction(index),
                    onDelete: () => _deleteIntroduction(index),
                    onCopy: () => _copyIntroduction(index),
                    onModify: () => _modifyIntroduction(index)
                )

                /*
                // 옵션 팝업 메뉴
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    // 옵션: 미리보기 다이얼로그
                    if (value == 'preview') {
                      _previewIntroduction(index);
                      /*
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '제목: ${_introductions[index]['title']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '회사: ${_introductions[index]['company']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '직무: ${_introductions[index]['jobTitle']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        );

                       */
                    }

                    // 옵션: 삭제하기 다이얼로그
                    else if (value == 'delete') {
                      _deleteIntroduction(index);
                    }
                    else if (value == 'copy'){
                      _copyIntroduction(index);
                    }
                    else if (value == 'modify'){
                      _modifyIntroduction(index);
                    }
                  },


                  // 옵션 팝업메뉴 항목
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                          value: 'preview',
                          child: Center(
                            child: Text(
                              '미리보기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            ),
                          )
                      ),
                      const PopupMenuItem(
                          value: 'modify',
                          child: Center(
                            child: Text(
                              '수정하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            ),
                          )
                      ),
                      const PopupMenuItem(
                          value: 'delete',
                          child: Center(
                            child: Text(
                              '삭제하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            ),
                          )
                      ),
                      const PopupMenuItem(
                          value: 'copy',
                          child: Center(
                              child: Text(
                                '복사하기',
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

                 */
              ],
            ),
          );
        },
      ),
    );
  }
}


