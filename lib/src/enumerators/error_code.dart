/// Created by luis901101 on 2020-01-09.
enum ErrorCode {
  SUCCESS,
  EXCEPTION,
  PRINTER_ERROR,
  UNKNOWN,
}

extension ErrorCodeUtils on ErrorCode {
  String get name => toString().split('.').last;

  static ErrorCode? valueOf(String name) {
    for (ErrorCode value in ErrorCode.values)
      if (value.name == name) return value;
    return ErrorCode.UNKNOWN;
  }
}
