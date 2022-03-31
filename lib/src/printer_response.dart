import 'package:zsdk/src/enumerators/cause.dart';
import 'package:zsdk/src/enumerators/error_code.dart';
import 'package:zsdk/src/printer_settings.dart';
import 'package:zsdk/src/enumerators/status.dart';
import 'package:zsdk/src/status_info.dart';

/// Created by luis901101 on 2020-01-07.
class PrinterResponse {
  ErrorCode errorCode;
  StatusInfo statusInfo;
  PrinterSettings? settings;
  String? message;

  PrinterResponse(
      {ErrorCode? errorCode,
      StatusInfo? statusInfo,
      this.settings,
      this.message})
      : errorCode = errorCode ?? ErrorCode.UNKNOWN,
        statusInfo = statusInfo ?? StatusInfo(Status.UNKNOWN, Cause.UNKNOWN);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'errorCode': errorCode.name,
        'statusInfo': statusInfo.toMap(),
        'settings': settings?.toMap(),
        'message': message,
      };

  factory PrinterResponse.fromMap(Map<dynamic, dynamic> map) => PrinterResponse(
        errorCode: ErrorCodeUtils.valueOf(map['errorCode']),
        statusInfo: map['statusInfo'] == null
            ? null
            : StatusInfo.fromMap(map['statusInfo']),
        settings: map['settings'] == null
            ? null
            : PrinterSettings.fromMap(map['settings']),
        message: map['message'],
      );
}
