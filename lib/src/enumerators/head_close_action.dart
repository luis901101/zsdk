/// Created by luis901101 on 2020-02-11.
enum HeadCloseAction
{
    FEED,
    CALIBRATE,
    LENGTH,
    NO_MOTION,
    SHORT_CAL,
}

class HeadCloseActionUtils {

    HeadCloseActionUtils.get();

    HeadCloseAction valueOf(String name) {
        try {return _mapValueOfName[name];} catch (e) {}
        return null;
    }

    String nameOf(HeadCloseAction value) {
        try {return _mapNameOfValue[value];} catch (e) {}
        return null;
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
}