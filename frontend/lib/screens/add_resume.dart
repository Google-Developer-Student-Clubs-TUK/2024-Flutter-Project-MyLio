import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/screens/edit.dart';
import 'package:frontend/screens/my_resume_create_page.dart';
import 'package:get/get.dart';

void main(){
  runApp(Add_Resume());
}

class Add_Resume extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Add_Resume_State();
  }
}

class Add_Resume_State extends State<Add_Resume>{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('My 이력서', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,),)
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                width: 352,
                height: 92,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(251, 251, 251, 1),
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
                              color: Color.fromRGBO(144, 140, 255, 1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text('대표 이력서', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w500),),
                        ),
                        Spacer(),
                        PopupMenuButton(
                          color: Colors.white,
                            elevation: 8,
                            offset: Offset(0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)
                            ),
                            itemBuilder: (context){
                              return <PopupMenuEntry<dynamic>>[
                                PopupMenuItem(
                                    child: Center(
                                      child: Text('대표이력서 설정', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                                    ),
                                  onTap: (){

                                  },
                                ),
                                const PopupMenuDivider(
                                  height: 5,
                                ),
                                PopupMenuItem(
                                    child: Center(
                                      child: Text('수정하기', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                                    ),
                                onTap: (){
                                      Get.to(Edit());
                                },
                                ),
                                const PopupMenuDivider(
                                  height: 5,
                                ),
                                PopupMenuItem(
                                    child: Center(
                                    child: Text('삭제하기', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),),
                                  onTap: (){

                                  },
                                ),
                                const PopupMenuDivider(
                                  height: 5,
                                ),
                                PopupMenuItem(
                                    child: Center(
                                      child: Text('복사하기', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                                    ),
                                  onTap: (){

                                  },
                                )
                              ];
                            },
                          child: FaIcon(FontAwesomeIcons.ellipsisVertical, size: 15,),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("서비스 기획자 이력서", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),)
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: (){
                    Get.to(MyResumeCreatePage());
                  },
                  child: Text('+ 이력서 추가', style: TextStyle(fontSize: 14, color: Colors.grey),),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(352, 47),  // 너비 352, 높이 47
                  backgroundColor: Colors.white,  // 배경 흰색
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black,  // 테두리 색상
                      width: 1,  // 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}