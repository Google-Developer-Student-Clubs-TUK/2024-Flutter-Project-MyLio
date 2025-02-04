import 'package:flutter/material.dart';
import 'package:frontend/screens/coverletter_edit.dart';
import '../theme/app_colors.dart';

class IntroductionListPopupMenuBtn extends StatelessWidget {
  final String resumeTitle;

  const IntroductionListPopupMenuBtn({
    super.key,
    required this.resumeTitle,
    required Null Function() onModifyPressed,
  });

  void _showPreviewDialog(BuildContext context) {
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
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
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
                Text(
                  resumeTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
                const SizedBox(height: 30),
                const Text(
                  '정말 삭제하시겠습니까?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.color2,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        print('Item Deleted');
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '예',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(100, 44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: AppColor.color2)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '아니요',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.color2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        if (value == 'preview') {
          _showPreviewDialog(context);
        } else if (value == 'delete') {
          _showDeleteDialog(context);
        } else if (value == 'modify') {
          // "수정하기"를 클릭하면 coverletter_edit.dart로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoverLetterEdit(
                resumeTitle: resumeTitle,
                questions: [],
              ),
            ),
          );
        } else {
          print('Selected: $value for $resumeTitle');
        }
      },
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
            ),
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
            ),
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
            ),
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
                    fontSize: 12),
              ),
            ),
          ),
        ];
      },
    );
  }
}
