import 'package:flutter/material.dart';
import 'package:valid_sudoku/screens/select_difficulty.dart';
import 'package:valid_sudoku/widgets/menu_button.dart';

class SelectMode extends StatelessWidget {
  final bool isTipsOn;

  const SelectMode({
    super.key,
    required this.isTipsOn
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SELECT MODE',
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
              text: 'Auto Generate',
              color: MaterialStateProperty.all(Colors.green),
              onPressed: () => Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => SelectDifficulty(isTipsOn: isTipsOn)
                                 )
                               )
            ),
            const SizedBox(height: 10),
            MenuButton(
              text: 'My Draft',
              color: MaterialStateProperty.all(Colors.green),
              onPressed: () {
                // TODO: create draft screen or something else.
              }
            ),
            const SizedBox(height: 10),
            MenuButton(
              text: 'Back',
              color: MaterialStateProperty.all(Colors.yellow),
              onPressed: () => Navigator.pop(context)
            )
          ]
        )
      )
    );
  }
}
