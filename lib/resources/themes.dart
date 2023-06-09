import 'package:flutter/material.dart';
import 'package:valid_sudoku/resources/text_styles.dart';

class AppThemes {
  static final lightTheme = ThemeData(
      canvasColor: Colors.deepPurple[100],
      textTheme: TextTheme(
        bodyLarge: AppTextStyles.titleTextStyle
      ),
      appBarTheme: AppBarTheme(
          color: Colors.deepPurple[100]
      )
  );

  static final darkTheme = ThemeData(
      canvasColor: const Color.fromRGBO(30, 31, 34, 20),
      textTheme: TextTheme(
        bodyLarge: AppTextStyles.titleTextStyle.copyWith(color: Colors.white)
      ),
      appBarTheme: const AppBarTheme(
        color: Color.fromRGBO(43, 45, 48, 20)
      )
  );
}
