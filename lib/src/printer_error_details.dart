
import 'package:zsdk/src/cause.dart';
import 'package:zsdk/src/status.dart';
import 'package:zsdk/src/status_info.dart';

/// Created by luis901101 on 2020-01-07.
class PrinterErrorDetails
{
    StatusInfo statusInfo;
    String message;

    PrinterErrorDetails(this.statusInfo, this.message) {
        this.statusInfo ??= StatusInfo(Status.UNKNOWN, Cause.UNKNOWN);
        this.message = message;
    }

    factory PrinterErrorDetails.fromMap(Map<dynamic, dynamic> map) =>
        map != null ?
        PrinterErrorDetails(
            StatusInfo.fromMap(map['statusInfo']),
            map['message'],
        ) : null;
}
