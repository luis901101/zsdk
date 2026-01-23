package com.plugin.flutter.zsdk;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.zebra.sdk.comm.BluetoothConnection;
import com.zebra.sdk.comm.Connection;
import com.zebra.sdk.printer.PrinterLanguage;
import com.zebra.sdk.printer.ZebraPrinter;
import com.zebra.sdk.printer.ZebraPrinterFactory;
import com.zebra.sdk.printer.discovery.BluetoothDiscoverer;
import com.zebra.sdk.printer.discovery.DiscoveredPrinter;
import com.zebra.sdk.printer.discovery.DiscoveryHandler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
//import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ZsdkPlugin */
public class ZsdkPlugin implements FlutterPlugin, MethodCallHandler {

  private Connection activeBluetoothConnection = null;
  private String connectedBluetoothAddress = null;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    init(
        flutterPluginBinding.getApplicationContext(),
        flutterPluginBinding.getBinaryMessenger()
    );
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (activeBluetoothConnection != null) {
      try {
        activeBluetoothConnection.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
      activeBluetoothConnection = null;
      connectedBluetoothAddress = null;
    }
    if(channel != null) channel.setMethodCallHandler(null);
  }

  // This static method is only to remain compatible with apps that don’t use the v2 Android embedding.
  /*@Deprecated()
  @SuppressLint("Registrar")
  public static void registerWith(Registrar registrar)
  {
    new ZsdkPlugin().init(
        registrar.context(),
        registrar.messenger()
    );
  }*/

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
  static final String _REBOOT_PRINTER_OVER_TCP_IP = "rebootPrinterOverTCPIP";

  /** Methods - Bluetooth */
  static final String _PRINT_PDF_FILE_OVER_BLUETOOTH = "printPdfFileOverBluetooth";
  static final String _PRINT_ZPL_FILE_OVER_BLUETOOTH = "printZplFileOverBluetooth";
  static final String _PRINT_ZPL_DATA_OVER_BLUETOOTH = "printZplDataOverBluetooth";
  static final String _CHECK_PRINTER_STATUS_OVER_BLUETOOTH = "checkPrinterStatusOverBluetooth";
  static final String _GET_PRINTER_SETTINGS_OVER_BLUETOOTH = "getPrinterSettingsOverBluetooth";
  static final String _SET_PRINTER_SETTINGS_OVER_BLUETOOTH = "setPrinterSettingsOverBluetooth";
  static final String _DO_MANUAL_CALIBRATION_OVER_BLUETOOTH = "doManualCalibrationOverBluetooth";
  static final String _PRINT_CONFIGURATION_LABEL_OVER_BLUETOOTH = "printConfigurationLabelOverBluetooth";
  static final String _REBOOT_PRINTER_OVER_BLUETOOTH = "rebootPrinterOverBluetooth";

  /** Methods - Bluetooth Connection Management */
  static final String _CONNECT_BLUETOOTH = "connectBluetooth";
  static final String _DISCONNECT_BLUETOOTH = "disconnectBluetooth";
  static final String _IS_BLUETOOTH_CONNECTED = "isBluetoothConnected";
  static final String _GET_BONDED_DEVICES = "getBondedDevices";
  static final String _DISCOVER_BLUETOOTH_PRINTERS = "discoverBluetoothPrinters";

  /** Properties */
  static final String _filePath = "filePath";
  static final String _data = "data";
  static final String _address = "address";
  static final String _port = "port";
  static final String _macAddress = "macAddress";
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
      switch (call.method) {
        case _CONNECT_BLUETOOTH:
          connectBluetooth(call.argument(_macAddress), result);
          return;
        case _DISCONNECT_BLUETOOTH:
          disconnectBluetooth(result);
          return;
        case _IS_BLUETOOTH_CONNECTED:
          String checkAddress = call.argument(_macAddress);
          result.success(isBluetoothConnected(checkAddress));
          return;
        case _GET_BONDED_DEVICES:
          getBondedDevices(result);
          return;
        case _DISCOVER_BLUETOOTH_PRINTERS:
          discoverBluetoothPrinters(result);
          return;
      }

      String requestedMac = call.argument(_macAddress);
      Connection connectionToUse = null;
      boolean shouldManageConnection = true;

      if (requestedMac != null && activeBluetoothConnection != null &&
              requestedMac.equalsIgnoreCase(connectedBluetoothAddress)) {
        try {
          if (activeBluetoothConnection.isConnected()) {
            connectionToUse = activeBluetoothConnection;
            shouldManageConnection = false;
          }
        } catch (Exception ignored) {
          activeBluetoothConnection = null;
          connectedBluetoothAddress = null;
        }
      }

      ZPrinter printer = new ZPrinter(
          context,
          channel,
          result,
          new PrinterConf(
              call.argument(_cmWidth),
              call.argument(_cmHeight),
              call.argument(_dpi),
              Orientation.getValueOfName(call.argument(_orientation))
          ),
          connectionToUse,
          shouldManageConnection
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
          printer.printPdfFileOverTCPIP(
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
        case _REBOOT_PRINTER_OVER_TCP_IP:
          printer.rebootPrinter(
              call.argument(_address),
              call.argument(_port)
          );
          break;
        case _DO_MANUAL_CALIBRATION_OVER_BLUETOOTH:
          printer.doManualCalibrationOverBluetooth(
              call.argument(_macAddress)
          );
          break;
        case _PRINT_CONFIGURATION_LABEL_OVER_BLUETOOTH:
          printer.printConfigurationLabelOverBluetooth(
              call.argument(_macAddress)
          );
          break;
        case _CHECK_PRINTER_STATUS_OVER_BLUETOOTH:
          printer.checkPrinterStatusOverBluetooth(
              call.argument(_macAddress)
          );
          break;
        case _GET_PRINTER_SETTINGS_OVER_BLUETOOTH:
          printer.getPrinterSettingsOverBluetooth(
              call.argument(_macAddress)
          );
          break;
        case _SET_PRINTER_SETTINGS_OVER_BLUETOOTH:
          printer.setPrinterSettingsOverBluetooth(
              call.argument(_macAddress),
              new PrinterSettings(call.arguments())
          );
          break;
        case _PRINT_PDF_FILE_OVER_BLUETOOTH:
          printer.printPdfFileOverBluetooth(
              call.argument(_filePath),
              call.argument(_macAddress)
          );
          break;
        case _PRINT_ZPL_FILE_OVER_BLUETOOTH:
          printer.printZplFileOverBluetooth(
              call.argument(_filePath),
              call.argument(_macAddress)
          );
          break;
        case _PRINT_ZPL_DATA_OVER_BLUETOOTH:
          printer.printZplDataOverBluetooth(
              call.argument(_data),
              call.argument(_macAddress)
          );
          break;
        case _REBOOT_PRINTER_OVER_BLUETOOTH:
          printer.rebootPrinterOverBluetooth(
              call.argument(_macAddress)
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

  private void connectBluetooth(String macAddress, Result result) {
    if (macAddress == null || macAddress.isEmpty()) {
      result.error("INVALID_ADDRESS", "MAC address is required", null);
      return;
    }

    if (activeBluetoothConnection != null) {
      try {
        activeBluetoothConnection.close();
      } catch (Exception e) {
        // Ignored
      }
      activeBluetoothConnection = null;
      connectedBluetoothAddress = null;
    }

    new Thread(() -> {
      try {
        BluetoothConnection connection = new BluetoothConnection(macAddress);
        connection.open();

        ZebraPrinter printer = ZebraPrinterFactory.getInstance(connection);
        PrinterLanguage language = printer.getPrinterControlLanguage();

        activeBluetoothConnection = connection;
        connectedBluetoothAddress = macAddress;

        new Handler(Looper.getMainLooper()).post(() -> {
          Map<String, Object> response = new HashMap<>();
          response.put("connected", true);
          response.put("address", macAddress);
          response.put("language", language.toString());
          result.success(response);
        });

      } catch (Exception e) {
        e.printStackTrace();
        activeBluetoothConnection = null;
        connectedBluetoothAddress = null;
        new Handler(Looper.getMainLooper()).post(() -> {
          result.error("CONNECTION_FAILED", "Failed to connect: " + e.getMessage(), null);
        });
      }
    }).start();
  }

  private void disconnectBluetooth(Result result) {
    if (activeBluetoothConnection == null) {
      result.success(true);
      return;
    }

    new Thread(() -> {
      try {
        activeBluetoothConnection.close();
      } catch (Exception e) {
        // Ignored
      }
      activeBluetoothConnection = null;
      connectedBluetoothAddress = null;

      new Handler(Looper.getMainLooper()).post(() -> {
        result.success(true);
      });
    }).start();
  }

  private boolean isBluetoothConnected(String macAddress) {
    if (activeBluetoothConnection == null || connectedBluetoothAddress == null) {
      return false;
    }
    if (macAddress != null && !macAddress.isEmpty()) {
      return macAddress.equalsIgnoreCase(connectedBluetoothAddress);
    }
    try {
      return activeBluetoothConnection.isConnected();
    } catch (Exception ignored) {
      return false;
    }
  }

  @SuppressWarnings("MissingPermission")
  private void getBondedDevices(Result result) {
    try {
      BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

      if (bluetoothAdapter == null) {
        result.error("BLUETOOTH_NOT_AVAILABLE", "Bluetooth is not available on this device", null);
        return;
      }

      Set<BluetoothDevice> bondedDevices = bluetoothAdapter.getBondedDevices();
      List<Map<String, String>> deviceList = new ArrayList<>();

      for (BluetoothDevice device : bondedDevices) {
        Map<String, String> deviceMap = new HashMap<>();
        deviceMap.put("name", device.getName() != null ? device.getName() : "Unknown");
        deviceMap.put("address", device.getAddress());
        deviceList.add(deviceMap);
      }

      result.success(deviceList);
    } catch (Exception e) {
      e.printStackTrace();
      result.error("BLUETOOTH_ERROR", "Failed to get bonded devices: " + e.getMessage(), null);
    }
  }

  private void discoverBluetoothPrinters(Result result) {
    new Thread(() -> {
      try {
        List<Map<String, String>> printerList = new ArrayList<>();

        BluetoothDiscoverer.findPrinters(context, new DiscoveryHandler() {
          @Override
          public void foundPrinter(DiscoveredPrinter printer) {
            Map<String, String> printerMap = new HashMap<>();
            printerMap.put("address", printer.address);
            String name = printer.getDiscoveryDataMap().get("FRIENDLY_NAME");
            printerMap.put("name", name != null ? name : "Zebra Printer");
            printerList.add(printerMap);
          }

          @Override
          public void discoveryFinished() {
            new Handler(Looper.getMainLooper()).post(() -> {
              result.success(printerList);
            });
          }

          @Override
          public void discoveryError(String message) {
            new Handler(Looper.getMainLooper()).post(() -> {
              result.error("DISCOVERY_ERROR", message, null);
            });
          }
        });

      } catch (Exception e) {
        e.printStackTrace();
        new Handler(Looper.getMainLooper()).post(() -> {
          result.error("DISCOVERY_ERROR", "Failed to discover printers: " + e.getMessage(), null);
        });
      }
    }).start();
  }
}
