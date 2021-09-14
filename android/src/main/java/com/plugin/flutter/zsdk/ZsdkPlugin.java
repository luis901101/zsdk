package com.plugin.flutter.zsdk;

import android.annotation.SuppressLint;
import android.content.Context;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ZsdkPlugin */
public class ZsdkPlugin implements FlutterPlugin, MethodCallHandler {

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    init(
        flutterPluginBinding.getApplicationContext(),
        flutterPluginBinding.getBinaryMessenger()
    );
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if(channel != null) channel.setMethodCallHandler(null);
  }

  // This static method is only to remain compatible with apps that don’t use the v2 Android embedding.
  @Deprecated()
  @SuppressLint("Registrar")
  public static void registerWith(Registrar registrar)
  {
    new ZsdkPlugin().init(
        registrar.context(),
        registrar.messenger()
    );
  }

  /** Channel */
  static final String _METHOD_CHANNEL = "zsdk";

  /** Methods */
  static final String _PRINT_PDF_FILE_OVER_TCP_IP = "printPdfFileOverTCPIP";
  static final String _PRINT_PDF_DATA_OVER_TCP_IP = "printPdfDataOverTCPIP";
  static final String _PRINT_ZPL_FILE_OVER_TCP_IP = "printZplFileOverTCPIP";
  static final String _PRINT_ZPL_DATA_OVER_TCP_IP = "printZplDataOverTCPIP";
  static final String _CHECK_PRINTER_STATUS_OVER_TCP_IP = "checkPrinterStatusOverTCPIP";
  static final String _GET_PRINTER_SETTINGS_OVER_TCP_IP = "getPrinterSettingsOverTCPIP";
  static final String _SET_PRINTER_SETTINGS_OVER_TCP_IP = "setPrinterSettingsOverTCPIP";
  static final String _DO_MANUAL_CALIBRATION_OVER_TCP_IP = "doManualCalibrationOverTCPIP";
  static final String _PRINT_CONFIGURATION_LABEL_OVER_TCP_IP = "printConfigurationLabelOverTCPIP";

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

  public ZsdkPlugin() {
  }

  private void init(Context context, BinaryMessenger messenger)
  {
    this.context = context;
    channel = new MethodChannel(messenger, _METHOD_CHANNEL);
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
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
        case _DO_MANUAL_CALIBRATION_OVER_TCP_IP:
          printer.doManualCalibrationOverTCPIP(
              call.argument(_address),
              call.argument(_port)
          );
          break;
        case _PRINT_CONFIGURATION_LABEL_OVER_TCP_IP:
          printer.printConfigurationLabelOverTCPIP(
              call.argument(_address),
              call.argument(_port)
          );
          break;
        case _CHECK_PRINTER_STATUS_OVER_TCP_IP:
          printer.checkPrinterStatusOverTCPIP(
              call.argument(_address),
              call.argument(_port)
          );
          break;
        case _GET_PRINTER_SETTINGS_OVER_TCP_IP:
          printer.getPrinterSettingsOverTCPIP(
              call.argument(_address),
              call.argument(_port)
          );
          break;
        case _SET_PRINTER_SETTINGS_OVER_TCP_IP:
          printer.setPrinterSettingsOverTCPIP(
              call.argument(_address),
              call.argument(_port),
              new PrinterSettings(call.arguments())
          );
          break;
        case _PRINT_PDF_FILE_OVER_TCP_IP:
          printer.printPdfOverTCPIP(
              call.argument(_filePath),
              call.argument(_address),
              call.argument(_port)
          );
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
        case _PRINT_PDF_DATA_OVER_TCP_IP:
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
