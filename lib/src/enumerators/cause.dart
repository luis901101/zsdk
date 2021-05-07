/// Created by luis901101 on 2020-01-07.
enum Cause {
  PARTIAL_FORMAT_IN_PROGRESS,
  HEAD_COLD,
  HEAD_OPEN,
  HEAD_TOO_HOT,
  PAPER_OUT,
  RIBBON_OUT,
  RECEIVE_BUFFER_FULL,
  NO_CONNECTION,
  UNKNOWN,
}

extension CauseUtils on Cause {
  String get name => toString().split('.').last;

  static Cause? valueOf(String name) {
    for (Cause value in Cause.values) if (value.name == name) return value;
    return Cause.UNKNOWN;
  }
}
