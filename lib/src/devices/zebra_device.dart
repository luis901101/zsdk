abstract class ZebraDevice {

  final String address;
  String friendlyName = "Unknown";

  String get addressString;
  String get statusAddressString;

  ZebraDevice(this.address, this.friendlyName);

}
