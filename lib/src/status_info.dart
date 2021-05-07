import 'package:zsdk/src/enumerators/cause.dart';
import 'package:zsdk/src/enumerators/status.dart';

/// Created by luis901101 on 2020-01-07.
class StatusInfo {
  final Status status;
  final Cause cause;

  StatusInfo(Status? status, Cause? cause)
      : this.status = status ?? Status.UNKNOWN,
        this.cause = cause ?? Cause.UNKNOWN;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'status': status.name,
        'cause': cause.name,
      };

  factory StatusInfo.fromMap(Map<dynamic, dynamic> map) => StatusInfo(
        StatusUtils.valueOf(map['status']),
        CauseUtils.valueOf(map['cause']),
      );
}
