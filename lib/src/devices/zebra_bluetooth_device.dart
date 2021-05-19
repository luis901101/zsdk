import 'package:zsdk/zsdk.dart';

class ZebraBluetoothDevice {

  final String mac;
  String friendlyName = "Unknown";

  ZebraBluetoothDevice(this.mac, this.friendlyName);

  Future<Map<String, Map<String, String>>> properties() => Future.value({});

  Future<PrinterResponse> sendZpl({required String data, PrinterConf? printerConfig}) => ZSDK().printZplData(data: data, address: mac, printerConf: printerConfig);

  Future<bool> isOnline() async => (await ZSDK().checkPrinterStatus(address: this.mac)).statusInfo.status == Status.READY_TO_PRINT;
}