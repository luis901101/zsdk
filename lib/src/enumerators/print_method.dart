/// Created by luis901101 on 2020-02-11.
enum PrintMethod {
  THERMAL_TRANS,
  DIRECT_THERMAL,
}

final _mapValueOfName = {
  'thermal trans': PrintMethod.THERMAL_TRANS,
  'direct thermal': PrintMethod.DIRECT_THERMAL,
};

final _mapNameOfValue = {
  PrintMethod.THERMAL_TRANS: 'thermal trans',
  PrintMethod.DIRECT_THERMAL: 'direct thermal',
};

extension PrintMethodUtils on PrintMethod {
  String get name => _mapNameOfValue[this]!;

  static PrintMethod? valueOf(String? name) => _mapValueOfName[name!];
}
