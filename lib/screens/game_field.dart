import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

class MyHomePage extends StatefulWidget {
  final int level;
  final bool isTipsOn;

  const MyHomePage({
    super.key,
    required this.level,
    required this.isTipsOn
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<List<TextEditingController>> sudoku = [];
  List<Widget> sudokuWidget = [];
  late SudokuGenerator sudokuGenerator;
  late bool _isTipsOn;

  @override
  void initState() {
    _isTipsOn = widget.isTipsOn;

    sudokuGenerator = SudokuGenerator(emptySquares: widget.level);

    var digitField = sudokuGenerator.newSudoku;

    for (int i = 0; i < 9; ++i) {
      sudoku.add([]);
      for (int j = 0; j < 9; ++j) {
        var controller = TextEditingController(
            text: digitField[i][j] != 0 ? digitField[i][j].toString() : ""
        );
        sudoku[i].add(controller);
      }
    }

    super.initState();
  }

  bool _isCorrectCell(int i, int j) {
    return sudoku[i][j].text.isEmpty || sudoku[i][j].text == sudokuGenerator.newSudokuSolved[i][j].toString();
  }

  List<Widget> _getSudokuWidget() {
    if (sudokuWidget.isNotEmpty) {
      sudokuWidget.clear();
    }

    var digitField = sudokuGenerator.newSudoku;

    for (int i = 0; i < 9; ++i) {
      List<Widget> sudokuColumn = <Widget>[];
      for (int j = 0; j < 9; ++j) {
        sudokuColumn.add(
            Expanded(
                child: TextField(
                    onChanged: (numberInput) {
                      setState(() {
                        sudoku[i][j].text = numberInput;
                      });
                    },
                    // enabled: digitField[i][j] == 0,
                    readOnly: digitField[i][j] != 0,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.deny("0")
                    ],
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
                    controller: sudoku[i][j],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: _isCorrectCell(i, j) ? Colors.black : Colors.red,
                    ),
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefix: null,
                        contentPadding: EdgeInsets.zero,
                        counter: null,
                        suffix: null,
                        counterText: "",
                        border: OutlineInputBorder()
                    )
                )
            )
        );

        if ((j + 1) % 3 == 0) {
          sudokuColumn.add(const SizedBox(height: 8));
        }
      }

      sudokuWidget.add(Expanded(child: Column(children: sudokuColumn)));

      if ((i + 1) % 3 == 0) {
        sudokuWidget.add(const SizedBox(width: 8));
      }
    }

    return sudokuWidget;
  }

  @override
  Widget build(BuildContext context) {
    double widthContainer = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Valid Sudoku',
          style: TextStyle(color: Colors.deepPurple)
        ),
        automaticallyImplyLeading: false,
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
              children: _getSudokuWidget()
            )
          )
        )
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'Clear',
            onPressed: () {
              for (int i = 0; i < 9; ++i) {
                for (int j = 0; j < 9; ++j) {
                  if (sudokuGenerator.newSudoku[i][j] == 0) {
                    sudoku[i][j].text = "";
                  }
                }
              }
            },
            tooltip: 'Clear all filled fields',
            label: const Text('Clear')
          ),
          const SizedBox(width: 10),
          FloatingActionButton.extended(
            heroTag: 'Finish',
            onPressed: () {
              // TODO: implement 'Finish' case.
            },
            tooltip: 'Finish solving task',
            label: const Text('Finish')),
          const SizedBox(width: 10),
          Visibility(
            visible: _isTipsOn,
            child: FloatingActionButton.extended(
              heroTag: 'Hint',
              onPressed: () {
                // TODO: implement 'Hint' case.
              },
              tooltip: 'Ask a random hint',
              label: const Text('Hint')
            )
          )
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
