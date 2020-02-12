/// Created by luis901101 on 2020-02-11.
enum PowerUpAction
{
    FEED,
    CALIBRATE,
    LENGTH,
    NO_MOTION,
    SHORT_CAL,
}

class PowerUpActionUtils {

    PowerUpActionUtils.get();

    PowerUpAction valueOf(String name) {
        try {return _mapValueOfName[name];} catch (e) {}
        return null;
    }

    String nameOf(PowerUpAction value) {
        try {return _mapNameOfValue[value];} catch (e) {}
        return null;
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
}