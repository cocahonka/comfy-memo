import 'package:flutter/material.dart';

class IconButtonWithCustomBackground extends StatelessWidget {
  const IconButtonWithCustomBackground({
    required IconButton iconButton,
    required this.backgroundColor,
    super.key,
  }) : _iconButton = iconButton;

  final IconButton _iconButton;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Ink(
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: backgroundColor,
            ),
          ),
        ),
        _iconButton,
      ],
    );
  }
}
