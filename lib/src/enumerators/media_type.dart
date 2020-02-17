/// Created by luis901101 on 2020-02-11.
enum MediaType
{
    CONTINUOUS,
    GAP_NOTCH,
    MARK,
}

class MediaTypeUtils {

    MediaTypeUtils.get();

    MediaType valueOf(String name) {
        try {return _mapValueOfName[name];} catch (e) {}
        return null;
    }

    String nameOf(MediaType value) {
        try {return _mapNameOfValue[value];} catch (e) {}
        return null;
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
}