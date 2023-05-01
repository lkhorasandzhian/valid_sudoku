class InvalidSudokuConfigurationException implements Exception {
  String errorMessage() => 'The configuration for the Sudoku puzzle is invalid.';

  @override
  String toString() => 'InvalidSudokuConfigurationException';
}

class InvalidEmptySquaresException implements Exception {
  String errorMessage() => 'The number of empty squares cannot be less than 1 or more than 81.';

  @override
  String toString() => 'InvalidEmptySquaresException';
}

class UnlikelyUniqueSolutionException implements Exception {
  String errorMessage() => 'The number of empty squares cannot more than 54 if a unique solution is needed.';

  @override
  String toString() => 'UnlikelyUniqueSolutionException';
}
