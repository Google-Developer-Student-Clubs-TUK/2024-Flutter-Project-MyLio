import 'package:flutter/material.dart';

class IntroductionPopupMenu extends StatelessWidget {
  final Function onPreview;
  final Function onDelete;
  final Function onCopy;
  final Function onModify;

  const IntroductionPopupMenu({
    Key? key,
    required this.onPreview,
    required this.onDelete,
    required this.onCopy,
    required this.onModify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        if (value == 'preview') {
          onPreview();
        } else if (value == 'delete') {
          onDelete();
        } else if (value == 'copy') {
          onCopy();
        } else if (value == 'modify') {
          onModify();
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
                  fontSize: 12,
                ),
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
                  fontSize: 12,
                ),
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
                  fontSize: 12,
                ),
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
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ];
      },
    );
  }
}
