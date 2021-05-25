import 'package:zsdk/zsdk.dart';

abstract class ZebraDevice {

  final String address;
  String friendlyName = "Unknown";

  String get addressString;
  String get statusAddressString;

  ZebraDevice(this.address, this.friendlyName);

  Future<Map<String, Map<String, String>>> properties();

  Future<PrinterResponse> sendZpl(
          {required String data, PrinterConf? printerConfig}) =>
      ZSDK().printZplData(
          data: data, address: this.addressString, printerConf: printerConfig);

  Future<bool> isOnline() async =>
      (await ZSDK().checkPrinterStatus(address: this.statusAddressString))
          .statusInfo
          .status ==
      Status.READY_TO_PRINT;
}
