import 'package:zsdk/src/devices/zebra_device.dart';

class ZebraBluetoothDevice extends ZebraDevice {

  String get addressString => "BT_MULTI:$address";
  String get statusAddressString => "BT_MULTI:$address";

  ZebraBluetoothDevice(String macAddress, String friendlyName): super(macAddress, friendlyName);

}