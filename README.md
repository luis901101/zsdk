# zsdk

### Zebra Link OS SDK Flutter plugin.
This is a flutter plugin for the Link-OS Multiplatform SDK for [Zebra](https://www.zebra.com/ap/en/support-downloads/printer-software/link-os-multiplatform-sdk.html)

### Features
- Print ZPL from String
- Print ZPL from file
- Print PDF from file (only Android)
- Printer calibration
- Get printer settings
- Set printer settings
- Reset printer settings to default
- Check printer status
- Print configuration label

**Currently this plugin only supports TCP/IP connection to the Printer.** 

### iOS Setup
```yaml
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end
```

### Android Setup
No setup required

## How to use

### Add dependency
```yaml
# Add this line to your flutter project dependencies
zsdk: ^2.0.0+11
```
and run `flutter pub get` to download the library sources to your pub-cache.

### Initialize a ZSDK object
```dart
final zsdk = ZSDK();
```

### Start the printer calibration
```dart
zsdk.doManualCalibrationOverTCPIP(
  address: '10.0.0.100', 
  port: 9100 //optional
)
```

### Get printer settings
```dart
zsdk.getPrinterSettingsOverTCPIP(
  address: '10.0.0.100', 
  port: 9100 //optional
).then(value) {
 final printerSettings = PrinterResponse.fromMap(value).settings;
};
```

### Set printer settings
```dart
zsdk.setPrinterSettingsOverTCPIP(
  address: '10.0.0.100', 
  port: 9100, //optional
  settings: PrinterSettings(
    darkness: 10,
    printSpeed: 6,
    tearOff: 0,
    mediaType: MediaType.MARK,
    printMethod: PrintMethod.DIRECT_THERMAL,
    printWidth: 568,
    labelLength: 1202,
    labelLengthMax: 39,
    zplMode: ZPLMode.ZPL_II,
    powerUpAction: PowerUpAction.NO_MOTION,
    headCloseAction: HeadCloseAction.NO_MOTION,
    labelTop: 0,
    leftPosition: 0,
    printMode: PrintMode.TEAR_OFF,
    reprintMode: ReprintMode.OFF,
  )
).then(value) {
  final printerResponse = PrinterResponse.fromMap(value);
  if(printerResponse.errorCode == ErrorCode.SUCCESS) {
    //Do something
  } else {
    Status status = printerResponse.statusInfo.status;
    Cause cause = printerResponse.statusInfo.cause;
    //Do something
  }
}
```

### Reset printer settings
```dart
zsdk.setPrinterSettingsOverTCPIP(
  address: '10.0.0.100', 
  port: 9100, //optional
  settings: PrinterSettings.defaultSettings()
).then(value) {
   final printerResponse = PrinterResponse.fromMap(value);
   if(printerResponse.errorCode == ErrorCode.SUCCESS) {
     //Do something
   } else {
     Status status = printerResponse.statusInfo.status;
     Cause cause = printerResponse.statusInfo.cause;
     //Do something
   }
 }
```

### Check printer status
```dart
zsdk.checkPrinterStatusOverTCPIP(
  address: '10.0.0.100', 
  port: 9100, //optional
).then(value) {
   final printerResponse = PrinterResponse.fromMap(value);
   Status status = printerResponse.statusInfo.status;
   print(status);
   if(printerResponse.errorCode == ErrorCode.SUCCESS) {
     //Do something 
   } else {
     Cause cause = printerResponse.statusInfo.cause;
     print(cause);
   }
 }
```

### Print zpl file
```dart
zsdk.printZplFileOverTCPIP(
  filePath: '/path/to/file.pdf',
  address: '10.0.0.100', 
  port: 9100, //optional
).then(value) {
   final printerResponse = PrinterResponse.fromMap(value);
   Status status = printerResponse.statusInfo.status;
   print(status);
   if(printerResponse.errorCode == ErrorCode.SUCCESS) {
     //Do something 
   } else {
     Cause cause = printerResponse.statusInfo.cause;
     print(cause);
   }
 }
```

### Print zpl data
```dart
zsdk.printZplDataOverTCPIP(
  data: '^XA^FO17,16^GB379,371,8^FS^FT65,255^A0N,135,134^FDTEST^FS^XZ',
  address: '10.0.0.100', 
  port: 9100, //optional
).then(value) {
   final printerResponse = PrinterResponse.fromMap(value);
   Status status = printerResponse.statusInfo.status;
   print(status);
   if(printerResponse.errorCode == ErrorCode.SUCCESS) {
     //Do something 
   } else {
     Cause cause = printerResponse.statusInfo.cause;
     print(cause);
   }
 }
```

### Print pdf file (only Android)
```dart
zsdk.printPdfFileOverTCPIP(
  filePath: '/path/to/file.pdf',
  address: '10.0.0.100', 
  port: 9100, //optional
).then(value) {
   final printerResponse = PrinterResponse.fromMap(value);
   Status status = printerResponse.statusInfo.status;
   print(status);
   if(printerResponse.errorCode == ErrorCode.SUCCESS) {
     //Do something 
   } else {
     Cause cause = printerResponse.statusInfo.cause;
     print(cause);
   }
 }
```


*Check the example code for more details*

### Tested Zebra Devices
- Zebra ZT411 
- Zebra ZD500 Series
