import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Valid Sudoku',
        theme: ThemeData.dark().copyWith(
            textTheme: const TextTheme(
                displayLarge: TextStyle(
                    fontSize: 72.0,
                    fontWeight: FontWeight.bold
                ),
                titleLarge: TextStyle(
                    fontSize: 36.0,
                    fontStyle: FontStyle.italic
                ),
                bodyMedium: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Times New Roman'
                )
            )
        ),
        home: const MyHomePage(),
        debugShowCheckedModeBanner: false
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<List<TextEditingController>> sudoku = [];
  List<Widget> sudokuWidget = [];

  @override
  void initState() {
    for (var i = 0; i < 9; ++i) {
      sudoku.add([]);
      List<Widget> sudokuColumn = <Widget>[];

      for (var l = 0; l < 9; ++l) {
        final TextEditingController controller = TextEditingController();
        sudoku[i].add(controller);

        sudokuColumn.add(
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              maxLength: 1,
              maxLines: 1,
              minLines: 1,
              scrollPadding: EdgeInsets.zero,
              autocorrect: false,
              buildCounter: null,
              keyboardType: TextInputType.number,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: controller,
              style: const TextStyle().copyWith(color: Colors.white),
              decoration: const InputDecoration(
                prefix: null,
                contentPadding: EdgeInsets.zero,
                counter: null,
                suffix: null,
                counterText: "",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        );

        if ((l + 1) % 3 == 0) {
          sudokuColumn.add(const SizedBox(height: 8));
        }
      }

      sudokuWidget.add(Expanded(child: Column(children: sudokuColumn)));

      if ((i + 1) % 3 == 0) {
        sudokuWidget.add(const SizedBox(width: 8));
      }
    }

    super.initState();
  }

  bool _isSave(row, col, number) {
    for (var i = 0; i < 9; ++i) {
      if (sudoku[i][col].text == number.toString() && i != row ||
          sudoku[row][i].text == number.toString() && i != col) {
        return false;
      }
    }

    int startRow = row - row % 3;
    int startColumn = col - col % 3;

    for (var i = 0; i < 3; ++i) {
      for (var j = 0; j < 3; ++j) {
        if (!(i + startRow == row && j + startColumn == col) &&
            sudoku[i + startRow][j + startColumn].text == number.toString()) {
          return false;
        }
      }
    }

    return true;
  }

  bool _solve([row = 0, col = 0]) {
    if (col == sudoku[0].length) {
      ++row;
      col = 0;
    }

    if (row == sudoku[0].length || col == sudoku[0].length) {
      return true;
    }

    if (int.parse(sudoku[row][col].text) > 0) {
      return _solve(row, col + 1);
    }

    for (var i = 1; i < 10; ++i) {
      if (_isSave(row, col, i)) {
        sudoku[row][col].text = i.toString();

        if (_solve(row, col + 1)) {
          return true;
        }
      }

      sudoku[row][col].text = "0";
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    double widthContainer = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Valid Sudoku')
        ),
        body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 500,
                  maxWidth: 500,
                ),
                child: SizedBox.square(
                    dimension: widthContainer,
                    child: Row(
                      children: sudokuWidget,
                    )
                )
            )
        ),
        floatingActionButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.extended(
                  onPressed: () {
                    for (var row in sudoku) {
                      for (var ctrl in row) {
                        ctrl.text = "";
                      }
                    }
                  },
                  tooltip: 'Clear',
                  label: const Text('Clear')
              ),
              const SizedBox(width: 10),
              FloatingActionButton.extended(
                  onPressed: () {
                    try {
                      for (var i = 0; i < sudoku.length; i++) {
                        for (var l = 0; l < sudoku[i].length; l++) {
                          if (sudoku[i][l].text == "") {
                            sudoku[i][l].text = "0";
                          } else if (!_isSave(i, l, int.parse(sudoku[i][l].text))) {
                            throw "Impossible";
                          }
                        }
                      }
                      if (!_solve()) {
                        throw "Not found solve";
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('It is impossible to solve this Sudoku! Check the input!'))
                      );
                    }
                  },
                  tooltip: 'Solve',
                  label: const Text('Solve')
              )
            ]
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
