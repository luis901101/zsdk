import 'package:zsdk/src/enumerators/cause.dart';
import 'package:zsdk/src/enumerators/error_code.dart';
import 'package:zsdk/src/printer_settings.dart';
import 'package:zsdk/src/enumerators/status.dart';
import 'package:zsdk/src/status_info.dart';

/// Created by luis901101 on 2020-01-07.
class PrinterResponse
{
    ErrorCode errorCode;
    StatusInfo statusInfo;
    PrinterSettings settings;
    String message;

    PrinterResponse({this.errorCode, this.statusInfo, this.settings, this.message}) {
        this.errorCode ??= ErrorCode.UNKNOWN;
        this.statusInfo ??= StatusInfo(Status.UNKNOWN, Cause.UNKNOWN);
    }

    Map<String, dynamic> toMap() => <String, dynamic>{
        'errorCode': ErrorCodeUtils.get().nameOf(errorCode),
        'statusInfo': statusInfo?.toMap(),
        'settings': settings?.toMap(),
        'message': message,
    };

    factory PrinterResponse.fromMap(Map<dynamic, dynamic> map) =>
        map != null ?
        PrinterResponse(
            errorCode: ErrorCodeUtils.get().valueOf(map['errorCode']),
            statusInfo: StatusInfo.fromMap(map['statusInfo']),
            settings: PrinterSettings.fromMap(map['settings']),
            message: map['message'],
        ) : null;
}
