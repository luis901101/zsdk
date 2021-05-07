/// Created by luis901101 on 2020-02-11.
enum ZPLMode {
  ZPL,
  ZPL_II,
}

final _mapValueOfName = {
  'zpl': ZPLMode.ZPL,
  'zpl II': ZPLMode.ZPL_II,
};

final _mapNameOfValue = {
  ZPLMode.ZPL: 'zpl',
  ZPLMode.ZPL_II: 'zpl II',
};

extension ZPLModeUtils on ZPLMode {
  String get name => _mapNameOfValue[this]!;

  static ZPLMode? valueOf(String? name) => _mapValueOfName[name!];
}
