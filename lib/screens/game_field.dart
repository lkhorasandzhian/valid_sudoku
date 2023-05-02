import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:valid_sudoku/containers/sudoku_master.dart';
import 'package:valid_sudoku/containers/coords.dart';

class GameField extends StatefulWidget {
  final int level;
  final bool isTipsOn;

  const GameField({
    super.key,
    required this.level,
    required this.isTipsOn
  });

  @override
  State<GameField> createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> {
  final List<List<TextEditingController>> sudoku = [];
  List<Widget> sudokuWidget = [];
  late SudokuGenerator sudokuGenerator;
  late bool _isTipsOn;
  late Coords _selectedCell;
  bool _hasSelectedCell = false;
  late int _tipsCounter;

  @override
  void initState() {
    _isTipsOn = widget.isTipsOn;

    if (_isTipsOn) {
      switch (widget.level) {
        case 27:
          _tipsCounter = 7;
          break;
        case 36:
          _tipsCounter = 5;
          break;
        case 54:
          _tipsCounter = 3;
          break;
        default:
          _tipsCounter = 81;
          break;
      }
    } else {
      _tipsCounter = 0;
    }

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
    return sudoku[i][j].text == sudokuGenerator.newSudokuSolved[i][j].toString();
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
                    onTap: () {
                      _selectedCell = Coords(i, j);
                      _hasSelectedCell = true;
                    },
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
              String message = 'Sudoku solved! You win!';
              bool isEmpty = false;
              bool isMistake = false;
              for (int i = 0; i < sudoku.length; ++i) {
                for (int j = 0; j < sudoku[i].length; ++j) {
                  if (sudoku[i][j].text.isEmpty) {
                    message = 'You haven\'t filled all empty cells...';
                    isEmpty = true;
                    break;
                  } else if (!_isCorrectCell(i, j)) {
                    message = 'There are mistakes in your solution. Please, try again...';
                    isMistake = true;
                  }
                }
                if (isEmpty) {
                  break;
                }
              }

              bool isValid = !isEmpty && !isMistake;

              if (!isValid) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: const Text('Notification'),
                        content: Text(message),
                        actions: [
                          TextButton(
                            child: const Text('Ok'),
                            onPressed: () => Navigator.pop(context),
                          )
                        ]
                    )
                );
                return;
              }

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Notification'),
                  content: Text(message),
                  actions: [
                    TextButton(
                      child: const Text('Stay at game'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('Return to main menu'),
                      onPressed: () {
                        for (var i = 0; i < 4; ++i) {
                          Navigator.pop(context);
                        }
                      },
                    )
                  ]
                )
              );
            },
            tooltip: 'Finish solving task',
            label: const Text('Finish')),
          const SizedBox(width: 10),
          Visibility(
            visible: _isTipsOn,
            child: FloatingActionButton.extended(
              heroTag: 'Hint',
              onPressed: () {
                if (!_hasSelectedCell || _isCorrectCell(_selectedCell.x, _selectedCell.y)) {
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text('Notification'),
                      content: Text('First click on the empty or incorrect cell you want to get as a hint'),
                    )
                  );
                  return;
                } else if (_tipsCounter == 0) {
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Text('Notification'),
                        content: Text('Oops... You have used all your tips!'),
                      )
                  );
                  return;
                }

                --_tipsCounter;

                int x = _selectedCell.x;
                int y = _selectedCell.y;
                var tipsField = sudokuGenerator.newSudokuSolved;

                setState(() => sudoku[x][y].text = tipsField[x][y].toString());
              },
              tooltip: 'Ask a hint for the selected cell',
              label: Text('Hint($_tipsCounter)')
            )
          ),
          const SizedBox(width: 10),
          FloatingActionButton.extended(
            heroTag: 'Surrender',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Notification'),
                  content: const Text("Do you really want to stop current game and return to main menu?"),
                  actions: [
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        for (var i = 0; i < 4; ++i) {
                          Navigator.pop(context);
                        }
                      }
                    )
                  ]
                )
              );
            },
            tooltip: 'Interrupt current game and exit',
            label: const Text('Surrender')
          )
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
