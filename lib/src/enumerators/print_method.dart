/// Created by luis901101 on 2020-02-11.
enum PrintMethod
{
    THERMAL_TRANS,
    DIRECT_THERMAL,
}

class PrintMethodUtils {

    PrintMethodUtils.get();

    PrintMethod valueOf(String name) {
        try {return _mapValueOfName[name];} catch (e) {}
        return null;
    }

    String nameOf(PrintMethod value) {
        try {return _mapNameOfValue[value];} catch (e) {}
        return null;
    }

    final _mapValueOfName = {
        'thermal trans': PrintMethod.THERMAL_TRANS,
        'direct thermal': PrintMethod.DIRECT_THERMAL,
    };

    final _mapNameOfValue = {
        PrintMethod.THERMAL_TRANS: 'thermal trans',
        PrintMethod.DIRECT_THERMAL: 'direct thermal',
    };
}