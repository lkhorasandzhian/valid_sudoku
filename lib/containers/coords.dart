class Coords {
  int _x;
  int _y;

  Coords(this._x, this._y);

  int get x => _x;

  set x(int value) {
    if (value >= 0 && value <= 8) {
      _x = value;
    } else {
      throw ArgumentError("Value must be in range [0;8]\n", "given value: $value");
    }
  }

  int get y => _y;

  set y(int value) {
    if (value >= 0 && value <= 8) {
      _y = value;
    } else {
      throw ArgumentError("Value must be in range [0;8]\n", "given value: $value");
    }
  }
}
