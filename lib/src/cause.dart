/// Created by luis901101 on 2020-01-07.
enum Cause
{
    PARTIAL_FORMAT_IN_PROGRESS,
    HEAD_COLD,
    HEAD_OPEN,
    HEAD_TOOHOT,
    PAPER_OUT,
    RIBBON_OUT,
    RECEIVE_BUFFER_FULL,
    NO_CONNECTION,
    UNKNOWN,
}

class CauseUtils {

    CauseUtils.get();

    Cause valueOf(String name) {
        try{
            return _mapValueOfName[name];
        } catch(e){
            return Cause.UNKNOWN;
        }
    }

    final _mapValueOfName = {
        'PARTIAL_FORMAT_IN_PROGRESS': Cause.PARTIAL_FORMAT_IN_PROGRESS,
        'HEAD_COLD': Cause.HEAD_COLD,
        'HEAD_OPEN': Cause.HEAD_OPEN,
        'HEAD_TOOHOT': Cause.HEAD_TOOHOT,
        'PAPER_OUT': Cause.PAPER_OUT,
        'RIBBON_OUT': Cause.RIBBON_OUT,
        'RECEIVE_BUFFER_FULL': Cause.RECEIVE_BUFFER_FULL,
        'NO_CONNECTION': Cause.NO_CONNECTION,
        'UNKNOWN': Cause.UNKNOWN,
    };

}