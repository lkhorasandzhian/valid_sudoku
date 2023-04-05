import 'package:flutter/material.dart';
import 'package:valid_sudoku/providers/theme_provider.dart';
import 'package:valid_sudoku/screens/main_menu.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
                 providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
                 child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valid Sudoku',
      theme: context.watch<ThemeProvider>().themeMode,
      home: const MainMenu(),
      debugShowCheckedModeBanner: false);
  }
}
