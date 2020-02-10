import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zsdk/src/orientation.dart';
import 'package:zsdk/src/printer_conf.dart';

export 'package:zsdk/src/cause.dart';
export 'package:zsdk/src/orientation.dart';
export 'package:zsdk/src/printer_conf.dart';
export 'package:zsdk/src/printer_response.dart';
export 'package:zsdk/src/status.dart';
export 'package:zsdk/src/status_info.dart';

class ZSDK {

  /// Channel
  static const String _METHOD_CHANNEL = "zsdk";

  /// Methods
  static const String _PRINT_PDF_FILE_OVER_TCP_IP = "printPdfFileOverTCPIP";
  static const String _PRINT_PDF_DATA_OVER_TCP_IP = "printPdfDataOverTCPIP";
  static const String _PRINT_ZPL_FILE_OVER_TCP_IP = "printZplFileOverTCPIP";
  static const String _PRINT_ZPL_DATA_OVER_TCP_IP = "printZplDataOverTCPIP";
  static const String _CHECK_PRINTER_STATUS_OVER_TCP_IP = "checkPrinterStatusOverTCPIP";
  static const String _GET_PRINTER_SETTINGS_OVER_TCP_IP = "getPrinterSettingsOverTCPIP";

  /// Properties
  static const String _filePath = "filePath";
  static const String _data = "data";
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

  Future checkPrinterStatusOverTCPIP({@required String address, int port}) =>
      _channel.invokeMethod(_CHECK_PRINTER_STATUS_OVER_TCP_IP, {
        _address: address,
        _port: port,
      });

  Future getPrinterSettingsOverTCPIP({@required String address, int port}) =>
      _channel.invokeMethod(_GET_PRINTER_SETTINGS_OVER_TCP_IP, {
        _address: address,
        _port: port,
      });

  Future printPdfFileOverTCPIP({@required String filePath, @required String address, int port, PrinterConf printerConf}) =>
      _printFileOverTCPIP(method: _PRINT_PDF_FILE_OVER_TCP_IP, filePath: filePath, address: address, port: port, printerConf: printerConf);

  Future printZplFileOverTCPIP({@required String filePath, @required String address, int port, PrinterConf printerConf}) =>
      _printFileOverTCPIP(method: _PRINT_ZPL_FILE_OVER_TCP_IP, filePath: filePath, address: address, port: port, printerConf: printerConf);

  Future _printFileOverTCPIP({@required method, @required String filePath, @required String address, int port, PrinterConf printerConf}) =>
    _channel.invokeMethod(method, {
    _filePath: filePath,
    _address: address,
    _port: port,
    _cmWidth: printerConf?.cmWidth,
    _cmHeight: printerConf?.cmHeight,
    _dpi: printerConf?.dpi,
    _orientation: OrientationUtils.get().nameOf(printerConf?.orientation),
  });

  Future printPdfDataOverTCPIP({@required ByteData data, @required String address, int port, PrinterConf printerConf}) =>
      _printDataOverTCPIP(method: _PRINT_PDF_DATA_OVER_TCP_IP, data: data, address: address, port: port, printerConf: printerConf);

  Future printZplDataOverTCPIP({@required String data, @required String address, int port, PrinterConf printerConf}) =>
      _printDataOverTCPIP(method: _PRINT_ZPL_DATA_OVER_TCP_IP, data: data, address: address, port: port, printerConf: printerConf);

  Future _printDataOverTCPIP({@required method, @required dynamic data, @required String address, int port, PrinterConf printerConf}) =>
    _channel.invokeMethod(method, {
    _data: data,
    _address: address,
    _port: port,
    _cmWidth: printerConf?.cmWidth,
    _cmHeight: printerConf?.cmHeight,
    _dpi: printerConf?.dpi,
    _orientation: OrientationUtils.get().nameOf(printerConf?.orientation),
  });

}