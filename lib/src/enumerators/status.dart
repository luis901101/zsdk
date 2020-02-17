/// Created by luis901101 on 2020-01-07.
enum Status
{
    PAUSED,
    READY_TO_PRINT,
    UNKNOWN,
}

class StatusUtils {

  StatusUtils.get();

  String nameOf(Status value) {
    try{return value?.toString()?.split(".")?.last;}catch(e){print(e);}
    return null;
  }

  Status valueOf(String name) {
    try{
      return _mapValueOfName[name];
    } catch(e){
      return Status.UNKNOWN;
    }
  }

  final _mapValueOfName = {
    'PAUSED': Status.PAUSED,
    'READY_TO_PRINT': Status.READY_TO_PRINT,
    'UNKNOWN': Status.UNKNOWN,
  };

}