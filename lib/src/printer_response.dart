
import 'package:zsdk/src/cause.dart';
import 'package:zsdk/src/error_code.dart';
import 'package:zsdk/src/status.dart';
import 'package:zsdk/src/status_info.dart';

/// Created by luis901101 on 2020-01-07.
class PrinterResponse
{
    ErrorCode errorCode;
    StatusInfo statusInfo;
    String message;

    PrinterResponse(this.errorCode, this.statusInfo, this.message) {
        this.errorCode ??= ErrorCode.UNKNOWN;
        this.statusInfo ??= StatusInfo(Status.UNKNOWN, Cause.UNKNOWN);
        this.message = message;
    }

    factory PrinterResponse.fromMap(Map<dynamic, dynamic> map) =>
        map != null ?
        PrinterResponse(
            ErrorCodeUtils.get().valueOf(map['errorCode']),
            StatusInfo.fromMap(map['statusInfo']),
            map['message'],
        ) : null;
}
