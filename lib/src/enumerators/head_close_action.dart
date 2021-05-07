/// Created by luis901101 on 2020-02-11.
enum HeadCloseAction {
  FEED,
  CALIBRATE,
  LENGTH,
  NO_MOTION,
  SHORT_CAL,
}

final _mapValueOfName = {
  'feed': HeadCloseAction.FEED,
  'calibrate': HeadCloseAction.CALIBRATE,
  'length': HeadCloseAction.LENGTH,
  'no motion': HeadCloseAction.NO_MOTION,
  'short cal': HeadCloseAction.SHORT_CAL,
};

final _mapNameOfValue = {
  HeadCloseAction.FEED: 'feed',
  HeadCloseAction.CALIBRATE: 'calibrate',
  HeadCloseAction.LENGTH: 'length',
  HeadCloseAction.NO_MOTION: 'no motion',
  HeadCloseAction.SHORT_CAL: 'short cal',
};

extension HeadCloseActionUtils on HeadCloseAction {
  String get name => _mapNameOfValue[this]!;

  static HeadCloseAction? valueOf(String? name) => _mapValueOfName[name];
}
