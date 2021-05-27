import 'package:zsdk/src/devices/zebra_device.dart';

class ZebraBluetoothDevice extends ZebraDevice {

  String get addressString => "BT:$address";
  String get statusAddressString => "BT_STATUS:$address";

  ZebraBluetoothDevice(String macAddress, String friendlyName): super(macAddress, friendlyName);

}