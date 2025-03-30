import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResumePopupMenuBtn extends StatelessWidget {
  final Function() onSetRepresentative;
  final Function() onEdit;
  final Function() onDelete;
  final Function() onDuplicate;

  const ResumePopupMenuBtn({
    Key? key,
    required this.onSetRepresentative,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.white,
      elevation: 1,
      offset: const Offset(0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      itemBuilder: (context) {
        return <PopupMenuEntry<dynamic>>[
          PopupMenuItem(
            child: const Center(
              child: Text(
                '대표이력서 설정',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            onTap: onSetRepresentative,
          ),
          const PopupMenuDivider(
            height: 5,
          ),
          PopupMenuItem(
            child: const Center(
              child: Text(
                '수정하기',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            onTap: onEdit,
          ),
          const PopupMenuDivider(
            height: 5,
          ),
          PopupMenuItem(
            child: const Center(
              child: Text(
                '삭제하기',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            onTap: onDelete,
          ),
          const PopupMenuDivider(
            height: 5,
          ),
          PopupMenuItem(
            child: const Center(
              child: Text(
                '복사하기',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            onTap: onDuplicate,
          ),
        ];
      },
      child: const FaIcon(
        FontAwesomeIcons.ellipsisVertical,
        size: 15,
      ),
    );
  }
}
