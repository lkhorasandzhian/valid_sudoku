import 'dart:io';
import 'exception.dart';

class SudokuFileLoader {
  static List<List<int?>> loadSudokuFromFile(String filePath) {
    try {
      // Чтение содержимого файла.
      File file = File(filePath);
      List<String> lines = file.readAsLinesSync();

      // Преобразование содержимого файла в двумерный список.
      List<List<int?>> sudokuData = lines.map((line) =>
          line.trim().split(' ').map((e) {
              int value = int.parse(e);
              if (value == 0) {
                return null;
              } else if (value < 1 || value > 9) {
                throw InvalidSudokuFileException();
              }
              return value;
          }).toList()
      ).toList();

      return sudokuData;
    } catch (e) {
      throw InvalidSudokuFileException();
    }
  }
}
