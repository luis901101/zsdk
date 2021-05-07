/// Created by luis901101 on 2020-02-11.
enum ReprintMode {
  ON,
  OFF,
}

final _mapValueOfName = {
  'on': ReprintMode.ON,
  'off': ReprintMode.OFF,
};

final _mapNameOfValue = {
  ReprintMode.ON: 'on',
  ReprintMode.OFF: 'off',
};

extension ReprintModeUtils on ReprintMode {
  String get name => _mapNameOfValue[this]!;

  static ReprintMode? valueOf(String? name) => _mapValueOfName[name!];
}
