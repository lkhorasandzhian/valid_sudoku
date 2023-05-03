import 'package:valid_sudoku/containers/sudoku_master/exception.dart';

class SudokuUtilities {
  static List<List<int>> copySudoku(List<List<int>> sudoku) {
    if (!isValidConfiguration(sudoku)) {
      throw InvalidSudokuConfigurationException();
    }
    var copiedSudoku = List.generate(9, (i) => List.generate(9, (j) => 0));
    for (int i = 0; i < 9; ++i) {
      for (int j = 0; j < 9; ++j) {
        copiedSudoku[i][j] = sudoku[i][j];
      }
    }
    return copiedSudoku;
  }

  static List<List<int>> makeNullSafe(List<List<int?>> sudoku) {
    var nullSafeSudoku = List.generate(9, (i) => List.generate(9, (j) => 0));
    try {
      for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
          nullSafeSudoku[i][j] = sudoku[i][j] ?? 0;
        }
      }
    } on RangeError {
      throw InvalidSudokuConfigurationException();
    }
    if (!isValidConfiguration(nullSafeSudoku)) {
      throw InvalidSudokuConfigurationException();
    }
    return nullSafeSudoku;
  }

  static bool isValidConfiguration(List<List<int?>> sudoku) {
    bool notInRow(List<List<int?>> sudoku, int rowNumber) {
      var numberSet = <int>{};
      for (int i = 0; i < 9; ++i) {
        if (numberSet.contains(sudoku[rowNumber][i])) {
          return false;
        } else if (sudoku[rowNumber][i] != 0 && sudoku[rowNumber][i] != null) {
          numberSet.add(sudoku[rowNumber][i]!);
        }
      }
      return true;
    }

    bool notInColumn(List<List<int?>> sudoku, int columnNumber) {
      var numberSet = <int>{};
      for (int i = 0; i < 9; ++i) {
        if (numberSet.contains(sudoku[i][columnNumber])) {
          return false;
        } else if (sudoku[i][columnNumber] != 0 &&
            sudoku[i][columnNumber] != null) {
          numberSet.add(sudoku[i][columnNumber]!);
        }
      }
      return true;
    }

    bool notInBox(List<List<int?>> sudoku, int startRow, int startColumn) {
      var numberSet = <int>{};
      for (int row = 0; row < 3; ++row) {
        for (var column = 0; column < 3; column++) {
          if (numberSet.contains(sudoku[row + startRow][column + startColumn])) {
            return false;
          } else if (sudoku[row + startRow][column + startColumn] != 0 &&
              sudoku[row + startRow][column + startColumn] != null) {
            numberSet.add(sudoku[row + startRow][column + startColumn]!);
          }
        }
      }
      return true;
    }

    bool isValid(List<List<int?>> sudoku, int rowNumber, int columnNumber) =>
        notInRow(sudoku, rowNumber) &&
        notInColumn(sudoku, columnNumber) &&
        notInBox(sudoku, rowNumber - rowNumber % 3, columnNumber - columnNumber % 3);

    bool containsValidValues(List<List<int?>> sudoku) {
      var validValueSet = <int?>{1, 2, 3, 4, 5, 6, 7, 8, 9, 0, null};
      for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
          if (!validValueSet.contains(sudoku[i][j])) {
            return false;
          }
        }
      }
      return true;
    }

    try {
      for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
          if (!isValid(sudoku, i, j)) {
            return false;
          }
        }
      }
    } on RangeError {
      return false;
    }

    if (!containsValidValues(sudoku)) {
      return false;
    }
    return true;
  }

  static bool hasUniqueSolution(List<List<int>> sudoku) {
    bool legal(List<List<int>> puzzle, int x, int y, int num) {
      int size = 9;
      int rowStart = x ~/ 3 * 3;
      int colStart = y ~/ 3 * 3;
      for (int i = 0; i < size; ++i) {
        if (puzzle[x][i] == num) {
          return false;
        }
        if (puzzle[i][y] == num) {
          return false;
        }
        if (puzzle[rowStart + (i % 3)][colStart + (i ~/ 3)] == num) {
          return false;
        }
      }
      return true;
    }

    int checkUniqueSolution(List<List<int>> puzzle, int x, int y, int count) {
      int size = 9;

      if (x == size) {
        x = 0;
        if (++y == size) {
          return 1 + count;
        }
      }

      if (puzzle[x][y] != 0) {
        return checkUniqueSolution(puzzle, x + 1, y, count);
      }

      for (int num = 1; (num <= size) && (count < 2); ++num) {
        if (legal(puzzle, x, y, num)) {
          puzzle[x][y] = num;
          count = checkUniqueSolution(puzzle, x + 1, y, count);
        }
      }
      puzzle[x][y] = 0;

      return count;
    }

    if (!isValidConfiguration(sudoku)) {
      throw InvalidSudokuConfigurationException();
    }
    return checkUniqueSolution(sudoku, 0, 0, 0) == 1;
  }
}
