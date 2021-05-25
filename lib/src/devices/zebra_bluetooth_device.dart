import 'package:zsdk/src/devices/zebra_device.dart';

class ZebraBluetoothDevice extends ZebraDevice {

  String get addressString => "$address";
  String get statusAddressString => "$address";

  ZebraBluetoothDevice(String macAddress, String friendlyName): super(macAddress, friendlyName);

  @override
  Future<Map<String, Map<String, String>>> properties() {
    // TODO: implement properties
    throw UnimplementedError();
  }

}