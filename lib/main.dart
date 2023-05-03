import 'package:flutter/material.dart';
import 'package:valid_sudoku/providers/theme_provider.dart';
import 'package:valid_sudoku/screens/main_menu.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle('Valid Sudoku');
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: const MyApp()));
  windowManager.setFullScreen(true);
  windowManager.setResizable(false);
}

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
