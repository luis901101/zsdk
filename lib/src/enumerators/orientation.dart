/// Created by luis901101 on 2020-01-07.
enum Orientation {
  PORTRAIT,
  LANDSCAPE,
}

extension OrientationUtils on Orientation {
  String get name => toString().split('.').last;

  static Orientation? valueOf(String name) {
    for (Orientation value in Orientation.values)
      if (value.name == name) return value;
    return Orientation.LANDSCAPE;
  }
}
