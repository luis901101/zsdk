/// Created by luis901101 on 2020-01-07.
enum Orientation {
    PORTRAIT,
    LANDSCAPE,
}

class OrientationUtils {

    OrientationUtils.get();

    Orientation valueOf(String name) {
        try{
            return _mapValueOfName[name];
        } catch(e){
            return Orientation.LANDSCAPE;
        }
    }

    String nameOf(Orientation value) {
        try{return value?.toString()?.split(".")?.last;}catch(e){print(e);}
        return null;
    }

    final _mapValueOfName = {
        'PORTRAIT': Orientation.PORTRAIT,
        'LANDSCAPE': Orientation.LANDSCAPE,
    };

}
