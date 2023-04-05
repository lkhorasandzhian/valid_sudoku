import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:valid_sudoku/screens/select_mode.dart';
import 'package:valid_sudoku/screens/settings.dart';
import 'package:valid_sudoku/widgets/menu_button.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<StatefulWidget> createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  bool isTipsOn = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SUDOKU',
          style: theme.textTheme.bodyLarge
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.canvasColor,
        automaticallyImplyLeading: false
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuButton(
              text: 'Play',
              color: MaterialStateProperty.all(Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectMode(isTipsOn: isTipsOn))
                );
              }
            ),
            const SizedBox(height: 10),
            MenuButton(
              text: 'Settings',
              color: MaterialStateProperty.all(Colors.green),
              onPressed: () async {
                isTipsOn = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings(lastIsTipsOn: isTipsOn))
                );
              }
            ),
            const SizedBox(height: 10),
            MenuButton(
              text: 'Exit',
              color: MaterialStateProperty.all(Colors.red),
              onPressed: () {
                debugPrint("kIsWeb = $kIsWeb");
                if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
                  exit(0);
                }
              }
            )
          ]
        )
      )
    );
  }
}
