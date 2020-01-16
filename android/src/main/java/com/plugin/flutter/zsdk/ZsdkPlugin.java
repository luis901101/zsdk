package com.plugin.flutter.zsdk;

import android.content.Context;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ZsdkPlugin */
public class ZsdkPlugin implements MethodCallHandler {

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) { new ZsdkPlugin(registrar);}

  /** Channel */
  static final String _METHOD_CHANNEL = "zsdk";

  /** Methods */
  static final String _PRINT_PDF_FILE_OVER_TCP_IP = "printPdfFileOverTCPIP";
  static final String _PRINT_PDF_DATA_OVER_TCP_IP = "printPdfDataOverTCPIP";
  static final String _PRINT_ZPL_FILE_OVER_TCP_IP = "printZplFileOverTCPIP";
  static final String _PRINT_ZPL_DATA_OVER_TCP_IP = "printZplDataOverTCPIP";
  static final String _CHECK_PRINTER_STATUS_OVER_TCP_IP = "checkPrinterStatusOverTCPIP";

  /** Properties */
  static final String _filePath = "filePath";
  static final String _data = "data";
  static final String _address = "address";
  static final String _port = "port";
  static final String _cmWidth = "cmWidth";
  static final String _cmHeight = "cmHeight";
  static final String _orientation = "orientation";
  static final String _dpi = "dpi";


  private MethodChannel channel;
  private Context context;

  public ZsdkPlugin(Registrar registrar)
  {
    context = registrar.context();
    channel = new MethodChannel(registrar.messenger(), _METHOD_CHANNEL);
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    try
    {
      ZPrinter printer = new ZPrinter(
          context,
          channel,
          result,
          new PrinterConf(
              call.argument(_cmWidth),
              call.argument(_cmHeight),
              call.argument(_dpi),
              Orientation.getValueOfName(call.argument(_orientation))
          )
      );
      switch(call.method){
        case _CHECK_PRINTER_STATUS_OVER_TCP_IP:
          printer.checkPrinterStatusOverTCPIP(
              call.argument(_address),
              call.argument(_port)
          );
          break;
        case _PRINT_PDF_FILE_OVER_TCP_IP:
          printer.printPdfOverTCPIP(
              call.argument(_filePath),
              call.argument(_address),
              call.argument(_port)
          );
          break;
        case _PRINT_PDF_DATA_OVER_TCP_IP:
          result.notImplemented();
          break;
        case _PRINT_ZPL_FILE_OVER_TCP_IP:
          printer.printZplFileOverTCPIP(
              call.argument(_filePath),
              call.argument(_address),
              call.argument(_port)
          );
          break;
        case _PRINT_ZPL_DATA_OVER_TCP_IP:
          printer.printZplDataOverTCPIP(
              call.argument(_data),
              call.argument(_address),
              call.argument(_port)
          );
          break;
        default:
          result.notImplemented();
      }
    }
    catch(Exception e)
    {
      e.printStackTrace();
      result.error(ErrorCode.EXCEPTION.name(), e.getMessage(), null);
    }
  }
}
