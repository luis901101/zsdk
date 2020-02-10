/// Created by luis901101 on 2020-02-10.
class PrinterSettings {
  final String printSpeed,
      mediaType,
      printMethod,
      tearOff,
      printWidth,
      printMode,
      labelTop,
      leftPosition,
      reprintMode,
      labelLengthMax;

  PrinterSettings({
    this.printSpeed,
    this.mediaType,
    this.printMethod,
    this.tearOff,
    this.printWidth,
    this.printMode,
    this.labelTop,
    this.leftPosition,
    this.reprintMode,
    this.labelLengthMax
  });

  String toString() =>
  """
  settings: {
    printSpeed: $printSpeed
    mediaType: $mediaType
    printMethod: $printMethod
    tearOff: $tearOff
    printWidth: $printWidth
    printMode: $printMode
    labelTop: $labelTop
    leftPosition: $leftPosition
    reprintMode: $reprintMode
    labelLengthMax: $labelLengthMax
  }
  """;

  factory PrinterSettings.fromMap(Map<dynamic, dynamic> map) => map != null
      ? PrinterSettings(
          printSpeed: map['printSpeed'],
          mediaType: map['mediaType'],
          printMethod: map['printMethod'],
          tearOff: map['tearOff'],
          printWidth: map['printWidth'],
          printMode: map['printMode'],
          labelTop: map['labelTop'],
          leftPosition: map['leftPosition'],
          reprintMode: map['reprintMode'],
          labelLengthMax: map['labelLengthMax'],
        )
      : null;
}
