import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final VoidCallback onGridPressed;
  final VoidCallback onSettingsPressed;
  final VoidCallback onFabPressed;

  const BottomBar({
    Key? key,
    required this.onGridPressed,
    required this.onSettingsPressed,
    required this.onFabPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // BottomAppBar for navigation buttons
        BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.grid_view, size: 24),
                onPressed: onGridPressed,
              ),
              const SizedBox(width: 48), // 중앙 FloatingActionButton 공간
              IconButton(
                icon: const Icon(Icons.settings, size: 24),
                onPressed: onSettingsPressed,
              ),
            ],
          ),
        ),
        // FloatingActionButton positioned in the center
        // Positioned(
        //   bottom: 40.0, // 버튼을 적절히 위로 배치
        //   child: Container(
        //     height: 70.0,
        //     width: 70.0,
        //     decoration: const BoxDecoration(
        //       shape: BoxShape.circle,
        //       gradient: LinearGradient(
        //         colors: [
        //           Gradients.blue,
        //           Gradients.purple,
        //           Gradients.pink,
        //         ],
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //       ),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black26,
        //           blurRadius: 5,
        //           offset: Offset(0, 3),
        //         ),
        //       ],
        //     ),
        //     child: FloatingActionButton(
        //       shape: const CircleBorder(),
        //       onPressed: onFabPressed,
        //       elevation: 0,
        //       highlightElevation: 0,
        //       hoverElevation: 0,
        //       focusElevation: 0,
        //       backgroundColor: Colors.transparent,
        //       child: const Icon(Icons.add, size: 41, color: Colors.white),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
