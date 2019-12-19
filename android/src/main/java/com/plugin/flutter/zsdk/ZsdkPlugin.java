package com.plugin.flutter.zsdk;

import android.content.Context;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** BlueBirdScannerPlugin */
public class ZsdkPlugin implements MethodCallHandler {

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) { new ZsdkPlugin(registrar);}

  /** Channel */
  static final String _METHOD_CHANNEL = "zsdk";

  /** Methods */
  static final String _PRINT_PDF_OVER_TCP_IP = "printPdfOverTCPIP";

  /** Properties */
  static final String _filePath = "filePath";
  static final String _address = "address";
  static final String _port = "port";


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
      switch(call.method){
        case _PRINT_PDF_OVER_TCP_IP:
          new ZPdfPrinter(context, channel, result)
            .printPdfOverTCPIP(call.argument(_filePath), call.argument(_address), call.argument(_port));
          break;
        default:
          result.notImplemented();
      }
    }
    catch(Exception e)
    {
      e.printStackTrace();
      result.error(e.getMessage(), null, null);
    }
  }
}
