import 'package:zsdk/src/cause.dart';
import 'package:zsdk/src/status.dart';

/// Created by luis901101 on 2020-01-07.
class StatusInfo
{
    final Status status;
    final Cause cause;

    StatusInfo(this.status, this.cause);

    factory StatusInfo.fromMap(Map<dynamic, dynamic> map) =>
        map != null ?
        StatusInfo(
            StatusUtils.get().valueOf(map['status']),
            CauseUtils.get().valueOf(map['cause']),
        ) : null;
}
