import 'package:flutter/material.dart';
import 'package:valid_sudoku/resources/text_styles.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final MaterialStateProperty<Color> color;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 250,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: color),
        onPressed: onPressed,
        child: Text(text, style: AppTextStyles.buttonTextStyle)
      )
    );
  }
}
