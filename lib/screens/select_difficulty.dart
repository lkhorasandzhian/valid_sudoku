import 'package:flutter/material.dart';
import 'package:valid_sudoku/screens/game_field.dart';
import 'package:valid_sudoku/widgets/menu_button.dart';

class SelectDifficulty extends StatelessWidget {
  final bool isTipsOn;

  const SelectDifficulty({
    super.key,
    required this.isTipsOn
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SELECT DIFFICULTY',
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
              text: 'Easy',
              color: MaterialStateProperty.all(Colors.green),
              onPressed: () => Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => GameField(level: 27, isTipsOn: isTipsOn)
                                 )
                               )
            ),
            const SizedBox(height: 10),
            MenuButton(
              text: 'Medium',
              color: MaterialStateProperty.all(Colors.orange),
              onPressed: () => Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => GameField(level: 36, isTipsOn: isTipsOn)
                                 )
                               )
            ),
            const SizedBox(height: 10),
            MenuButton(
              text: 'Hard',
              color: MaterialStateProperty.all(Colors.red),
              onPressed: () => Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => GameField(level: 54, isTipsOn: isTipsOn)
                                 )
                               )
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
