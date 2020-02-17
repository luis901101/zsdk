import 'package:zsdk/src/enumerators/cause.dart';
import 'package:zsdk/src/enumerators/status.dart';

/// Created by luis901101 on 2020-01-07.
class StatusInfo
{
    final Status status;
    final Cause cause;

    StatusInfo(this.status, this.cause);

    Map<String, dynamic> toMap() => <String, dynamic>{
        'status': StatusUtils.get().nameOf(status),
        'cause': CauseUtils.get().nameOf(cause),
    };

    factory StatusInfo.fromMap(Map<dynamic, dynamic> map) =>
        map != null ?
        StatusInfo(
            StatusUtils.get().valueOf(map['status']),
            CauseUtils.get().valueOf(map['cause']),
        ) : null;
}
