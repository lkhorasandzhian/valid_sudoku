import 'package:valid_sudoku/containers/sudoku_master/utility.dart';

class SudokuSolver {
  static List<List<int>> solve(List<List<int?>> sudoku) {
    var solvedGrid = SudokuUtilities.makeNullSafe(sudoku);
    _solveImplementation(solvedGrid);
    return solvedGrid;
  }

  static List<int>? _findEmpty(List<List<int>> sudoku) {
    for (int i = 0; i < 9; ++i) {
      for (int j = 0; j < 9; ++j) {
        if (sudoku[i][j] == 0) {
          return [i, j];
        }
      }
    }
    return null;
  }

  static bool _valid(List<List<int>> sudoku, int number, List<int> position) {
    for (int i = 0; i < 9; ++i) {
      if (sudoku[position[0]][i] == number && position[1] != i) {
        return false;
      }
    }

    for (int i = 0; i < 9; ++i) {
      if (sudoku[i][position[1]] == number && position[0] != i) {
        return false;
      }
    }

    int boxX = position[1] ~/ 3;
    int boxY = position[0] ~/ 3;
    for (int i = boxY * 3; i < boxY * 3 + 3; ++i) {
      for (int j = boxX * 3; j < boxX * 3 + 3; ++j) {
        if (sudoku[i][j] == number && [i, j] != position) {
          return false;
        }
      }
    }

    return true;
  }

  static bool _solveImplementation(List<List<int>> sudoku) {
    int row;
    int column;

    var coords = _findEmpty(sudoku);
    if (coords == null) {
      return true;
    } else {
      row = coords[0];
      column = coords[1];
    }

    for (int i = 1; i <= 9; ++i) {
      if (_valid(sudoku, i, [row, column])) {
        sudoku[row][column] = i;
        if (_solveImplementation(sudoku)) {
          return true;
        }
        sudoku[row][column] = 0;
      }
    }

    return false;
  }
}
