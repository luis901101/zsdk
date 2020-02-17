
/// Created by luis901101 on 2020-01-09.
enum ErrorCode
{
    SUCCESS,
    EXCEPTION,
    PRINTER_ERROR,
    UNKNOWN,
}

class ErrorCodeUtils {

    ErrorCodeUtils.get();

    String nameOf(ErrorCode value) {
        try{return value?.toString()?.split(".")?.last;}catch(e){print(e);}
        return null;
    }

    ErrorCode valueOf(String name) {
        try{
            return _mapValueOfName[name];
        } catch(e){
            return ErrorCode.UNKNOWN;
        }
    }

    final _mapValueOfName = {
        'SUCCESS': ErrorCode.SUCCESS,
        'EXCEPTION': ErrorCode.EXCEPTION,
        'PRINTER_ERROR': ErrorCode.PRINTER_ERROR,
        'UNKNOWN': ErrorCode.UNKNOWN,
    };

}
