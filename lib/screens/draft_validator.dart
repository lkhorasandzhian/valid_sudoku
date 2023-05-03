import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:valid_sudoku/containers/sudoku_master.dart';
import 'package:valid_sudoku/screens/game_field.dart';

class DraftValidator extends StatefulWidget {
  final bool isTipsOn;

  const DraftValidator({
    super.key,
    required this.isTipsOn
  });

  @override
  State<DraftValidator> createState() => _DraftValidatorState();
}

class _DraftValidatorState extends State<DraftValidator> {
  final List<List<TextEditingController>> sudoku = [];
  List<Widget> sudokuWidget = [];

  @override
  void initState() {
    for (int i = 0; i < 9; ++i) {
      sudoku.add([]);
      for (int j = 0; j < 9; ++j) {
        var controller = TextEditingController(text: "");
        sudoku[i].add(controller);
      }
    }

    super.initState();
  }

  List<List<int>> _castToDigitField(List<List<TextEditingController>> data) {
    var digitField = List.generate(9, (i) => List.generate(9, (j) => 0));

    for (int i = 0; i < 9; ++i) {
      for (int j = 0; j < 9; ++j) {
        if (sudoku[i][j].text.isNotEmpty) {
          digitField[i][j] = int.parse(sudoku[i][j].text);
        } else {
          digitField[i][j] = 0;
        }
      }
    }

    return digitField;
  }

  int _countOfEmptyCells(List<List<int>> field) {
    var counter = 0;

    for (int i = 0; i < 9; ++i) {
      for (int j = 0; j < 9; ++j) {
        if (field[i][j] == 0) {
          ++counter;
        }
      }
    }

    return counter;
  }

  List<Widget> _getSudokuWidget() {
    if (sudokuWidget.isNotEmpty) {
      sudokuWidget.clear();
    }

    for (int i = 0; i < 9; ++i) {
      List<Widget> sudokuColumn = <Widget>[];
      for (int j = 0; j < 9; ++j) {
        sudokuColumn.add(
            Expanded(
                child: TextField(
                    onTap: () {},
                    onChanged: (numberInput) {},
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black,
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
                heroTag: 'Back',
                onPressed: () => Navigator.pop(context),
                tooltip: 'Return to the mode selector',
                label: const Text('Back')
              ),
              const SizedBox(width: 10),
              FloatingActionButton.extended(
                  heroTag: 'Check and continue',
                  onPressed: () {
                    var task = _castToDigitField(sudoku);
                    List<List<int>>? solution;

                    int emptyCells = _countOfEmptyCells(task);

                    bool isCorrect = true;
                    String message = "Task was successfully uploaded!";

                    if (emptyCells > 64) {
                      isCorrect = false;
                      message = 'The task must have at least 17 filled cells, try again...';
                    } else {
                      bool wasException = false;

                      try {
                        isCorrect = SudokuUtilities.hasUniqueSolution(task);
                      } on InvalidSudokuConfigurationException {
                        wasException = true;
                        isCorrect = false;
                      }

                      if (isCorrect) {
                        solution = SudokuSolver.solve(task);
                      } else {
                        message = wasException ?
                          'The task must follow sudoku rules (\'Settings\' -> \'Rules\'), try again...' :
                          'The task must have unique solution, try again...';
                      }
                    }

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Notification'),
                        content: Text(message),
                        actions: [
                          TextButton(
                            child: Text(isCorrect ? 'Continue' : 'Ok'),
                            onPressed: () {
                              if (isCorrect) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameField(level: emptyCells,
                                      isTipsOn: widget.isTipsOn,
                                      taskField: task,
                                      solutionField: solution)
                                  )
                                );
                              } else {
                                Navigator.pop(context);
                              }
                            }
                          )
                        ]
                      )
                    );
                  },
                  tooltip: 'Finish creating task and start solving it',
                  label: const Text('Check and continue')
              ),
              const SizedBox(width: 10),
              FloatingActionButton.extended(
                  heroTag: 'Clear',
                  onPressed: () {
                    for (int i = 0; i < 9; ++i) {
                      for (int j = 0; j < 9; ++j) {
                        sudoku[i][j].text = "";
                      }
                    }
                  },
                  tooltip: 'Clear all fields',
                  label: const Text('Clear')
              )
            ]
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
