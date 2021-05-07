/// Created by luis901101 on 2020-02-11.
enum MediaType {
  CONTINUOUS,
  GAP_NOTCH,
  MARK,
}

final _mapValueOfName = {
  'continuous': MediaType.CONTINUOUS,
  'gap/notch': MediaType.GAP_NOTCH,
  'mark': MediaType.MARK,
};

final _mapNameOfValue = {
  MediaType.CONTINUOUS: 'continuous',
  MediaType.GAP_NOTCH: 'gap/notch',
  MediaType.MARK: 'mark',
};

extension MediaTypeUtils on MediaType {
  String get name => _mapNameOfValue[this]!;

  static MediaType? valueOf(String? name) => _mapValueOfName[name!];
}
