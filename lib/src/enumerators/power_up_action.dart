/// Created by luis901101 on 2020-02-11.
enum PowerUpAction {
  FEED,
  CALIBRATE,
  LENGTH,
  NO_MOTION,
  SHORT_CAL,
}

final _mapValueOfName = {
  'feed': PowerUpAction.FEED,
  'calibrate': PowerUpAction.CALIBRATE,
  'length': PowerUpAction.LENGTH,
  'no motion': PowerUpAction.NO_MOTION,
  'short cal': PowerUpAction.SHORT_CAL,
};

final _mapNameOfValue = {
  PowerUpAction.FEED: 'feed',
  PowerUpAction.CALIBRATE: 'calibrate',
  PowerUpAction.LENGTH: 'length',
  PowerUpAction.NO_MOTION: 'no motion',
  PowerUpAction.SHORT_CAL: 'short cal',
};

extension PowerUpActionUtils on PowerUpAction {
  String get name => _mapNameOfValue[this]!;

  static PowerUpAction? valueOf(String? name) => _mapValueOfName[name!];
}
