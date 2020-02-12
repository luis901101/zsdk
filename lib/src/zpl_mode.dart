/// Created by luis901101 on 2020-02-11.
enum ZPLMode
{
    ZPL,
    ZPL_II,
}

class ZPLModeUtils {

    ZPLModeUtils.get();

    ZPLMode valueOf(String name) {
        try {return _mapValueOfName[name];} catch (e) {}
        return null;
    }

    String nameOf(ZPLMode value) {
        try {return _mapNameOfValue[value];} catch (e) {}
        return null;
    }

    final _mapValueOfName = {
        'zpl': ZPLMode.ZPL,
        'zpl II': ZPLMode.ZPL_II,
    };

    final _mapNameOfValue = {
        ZPLMode.ZPL: 'zpl',
        ZPLMode.ZPL_II: 'zpl II',
    };
}