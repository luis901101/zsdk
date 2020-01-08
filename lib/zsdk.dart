import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zsdk/src/orientation.dart';
import 'package:zsdk/src/printer_conf.dart';

export 'package:zsdk/src/cause.dart';
export 'package:zsdk/src/orientation.dart';
export 'package:zsdk/src/printer_conf.dart';
export 'package:zsdk/src/printer_error_details.dart';
export 'package:zsdk/src/status.dart';
export 'package:zsdk/src/status_info.dart';

class ZSDK {

  /** Channel */
  static const String _METHOD_CHANNEL = "zsdk";

  /** Methods */
  static const String _PRINT_PDF_OVER_TCP_IP = "printPdfOverTCPIP";
  static const String _PRINT_ZPL_OVER_TCP_IP = "printZplOverTCPIP";

  /** Properties */
  static const String _filePath = "filePath";
  static const String _address = "address";
  static const String _port = "port";
  static const String _cmWidth = "cmWidth";
  static const String _cmHeight = "cmHeight";
  static const String _orientation = "orientation";
  static const String _dpi = "dpi";

  MethodChannel _channel;

  ZSDK() {
    _channel = const MethodChannel(_METHOD_CHANNEL);
    _channel.setMethodCallHandler(_onMethodCall);
  }

  Future _onMethodCall(MethodCall call) {
    try {
      switch (call.method) {
        default:
          print(call.arguments);
      }
    }
    catch(e)
    {
      print(e);
    }
    return null;
  }

  Future printPdfOverTCPIP({@required String filePath, @required String address, int port, PrinterConf printerConf}) =>
      _printOverTCPIP(method: _PRINT_PDF_OVER_TCP_IP, filePath: filePath, address: address, port: port, printerConf: printerConf);

  Future printZplOverTCPIP({@required String filePath, @required String address, int port, PrinterConf printerConf}) =>
    _printOverTCPIP(method: _PRINT_ZPL_OVER_TCP_IP, filePath: filePath, address: address, port: port, printerConf: printerConf);

  Future _printOverTCPIP({@required method, @required String filePath, @required String address, int port, PrinterConf printerConf}) =>
    _channel.invokeMethod(method, {
    _filePath: filePath,
    _address: address,
    _port: port,
    _cmWidth: printerConf?.cmWidth,
    _cmHeight: printerConf?.cmHeight,
    _dpi: printerConf?.dpi,
    _orientation: OrientationUtils.get().nameOf(printerConf?.orientation),
  });

}