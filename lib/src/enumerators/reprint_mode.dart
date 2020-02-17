/// Created by luis901101 on 2020-02-11.
enum ReprintMode
{
    ON,
    OFF,
}

class ReprintModeUtils {

    ReprintModeUtils.get();

    ReprintMode valueOf(String name) {
        try {return _mapValueOfName[name];} catch (e) {}
        return null;
    }

    String nameOf(ReprintMode value) {
        try {return _mapNameOfValue[value];} catch (e) {}
        return null;
    }

    final _mapValueOfName = {
        'on': ReprintMode.ON,
        'off': ReprintMode.OFF,
    };

    final _mapNameOfValue = {
        ReprintMode.ON: 'on',
        ReprintMode.OFF: 'off',
    };
}