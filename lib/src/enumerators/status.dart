/// Created by luis901101 on 2020-01-07.
enum Status {
  PAUSED,
  READY_TO_PRINT,
  UNKNOWN,
}

extension StatusUtils on Status {
  String get name => toString().split('.').last;

  static Status? valueOf(String name) {
    for (Status value in Status.values) {
      if (value.name == name) return value;
    }
    return Status.UNKNOWN;
  }
}
