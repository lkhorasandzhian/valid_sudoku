import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valid_sudoku/providers/theme_provider.dart';
import 'package:valid_sudoku/resources/text_styles.dart';
import 'package:valid_sudoku/widgets/menu_button.dart';

class Settings extends StatefulWidget {
  final bool lastIsTipsOn;

  const Settings({
    super.key,
    required this.lastIsTipsOn
  });

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  late bool isTipsOn;

  @override
  void initState() {
    isTipsOn = widget.lastIsTipsOn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS',
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
              text: 'Themes',
              color: MaterialStateProperty.all(Colors.green),
              onPressed: () => context.read<ThemeProvider>().changeTheme()
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 70,
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: isTipsOn ?
                                   MaterialStateProperty.all(Colors.green) :
                                   MaterialStateProperty.all(Colors.red)
                ),
                onPressed: () => (setState(() => isTipsOn = !isTipsOn)),
                child: Text(
                  'Tips',
                  style: AppTextStyles.buttonTextStyle
                )
              )
            ),
            const SizedBox(height: 10),
            MenuButton(
              text: 'Back',
              color: MaterialStateProperty.all(Colors.yellow),
              onPressed: () => Navigator.pop(context, isTipsOn)
            )
          ]
        )
      )
    );
  }
}
