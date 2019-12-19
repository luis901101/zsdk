import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ZSDK {

  /** Channel */
  static const String _METHOD_CHANNEL = "zsdk";

  /** Methods */
  static const String _PRINT_PDF_OVER_TCP_IP = "printPdfOverTCPIP";

  /** Properties */
  static const String _filePath = "filePath";
  static const String _address = "address";
  static const String _port = "port";

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
  }

  Future printPdfOverTCPIP({@required String filePath, @required String address, int port}) =>
    _channel.invokeMethod(_PRINT_PDF_OVER_TCP_IP, {
    _filePath: filePath,
    _address: address,
    _port: port,
  });

}