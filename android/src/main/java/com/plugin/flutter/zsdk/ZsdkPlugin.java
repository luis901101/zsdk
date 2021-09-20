package com.plugin.flutter.zsdk;

import android.content.Context;
import android.util.Log;

import com.zebra.sdk.comm.Connection;

import org.jetbrains.annotations.NotNull;

import java.util.function.Function;
import java.util.logging.Logger;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * ZsdkPlugin
 */
public class ZsdkPlugin implements MethodCallHandler, EventChannel.StreamHandler, FlutterPlugin {

    /**
     * Channel
     */
    static final String _METHOD_CHANNEL = "zsdk";
    static final String _EVENT_CHANNEL = "zsdk-events";

    /**
     * Methods
     */
    static final String _SEARCH_BLUETOOTH_DEVICES = "searchBluetoothDevices";
    static final String _CANCEL_BLUETOOTH_SEARCH = "cancelBluetoothSearch";
    static final String _CHECK_PRINTER_STATUS = "checkPrinterStatus";
    static final String _PRINT_ZPL_FILE = "printZplFile";
    static final String _PRINT_ZPL_DATA = "printZplData";
    static final String _DO_MANUAL_CALIBRATION = "doManualCalibration";
    static final String _GET_PRINTER_SETTINGS = "getPrinterSettings";
    static final String _SET_PRINTER_SETTINGS = "setPrinterSettings";
    static final String _PRINT_PDF_FILE_OVER_TCP_IP = "printPdfFileOverTCPIP";
    static final String _PRINT_PDF_DATA_OVER_TCP_IP = "printPdfDataOverTCPIP";
    static final String _PRINT_CONFIGURATION_LABEL_OVER_TCP_IP = "printConfigurationLabelOverTCPIP";

    /**
     * Properties
     */
    static final String _filePath = "filePath";
    static final String _data = "data";
    static final String _address = "address";
    static final String _macAddress = "macAddress";
    static final String _port = "port";
    static final String _cmWidth = "cmWidth";
    static final String _cmHeight = "cmHeight";
    static final String _orientation = "orientation";
    static final String _dpi = "dpi";

    private static Logger logger = Logger.getLogger(ZsdkDiscoveryHandler.class.getCanonicalName());

    private MethodChannel channel;
    EventChannel discoveryEventChannel;
    EventChannel.EventSink eventSink = null;
    private Context context;

    private Connection conn = null;
    private Function<Connection, ?> updateConnection = connection -> {
        this.conn = connection;
        return connection;
    };

    @Override
    public void onMethodCall(MethodCall call, @NotNull Result result) {

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
                discoveryEventChannel,
                eventSink,
                conn,
                updateConnection,
                this
        );

        try {
            switch (call.method) {
                case _SEARCH_BLUETOOTH_DEVICES:
                    printer.searchForBluetoothDevices(call.argument(_macAddress));
                    break;
                case _CANCEL_BLUETOOTH_SEARCH:
                    printer.cancelBluetoothDiscovery();
                    break;
                case _CHECK_PRINTER_STATUS:
                    printer.checkPrinterStatus(
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                case _PRINT_ZPL_FILE:
                    printer.printZplFile(
                            call.argument(_filePath),
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                case _PRINT_ZPL_DATA:
                    printer.printZplData(
                            call.argument(_data),
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                case _DO_MANUAL_CALIBRATION:
                    printer.doManualCalibration(
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                case _GET_PRINTER_SETTINGS:
                    printer.getPrinterSettings(
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                case _SET_PRINTER_SETTINGS:
                    printer.setPrinterSettings(
                            call.argument(_address),
                            call.argument(_port),
                            new PrinterSettings(call.arguments())
                    );
                    break;

                // ===

                case _PRINT_CONFIGURATION_LABEL_OVER_TCP_IP:
                    printer.printConfigurationLabelOverTCPIP(
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
                default:
                    result.notImplemented();
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.error(ErrorCode.EXCEPTION.name(), e.getMessage(), null);
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;

    }

    @Override
    public void onCancel(Object o) {
        this.eventSink = null;
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), _METHOD_CHANNEL);
        discoveryEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), _EVENT_CHANNEL);
        channel.setMethodCallHandler(this);
        discoveryEventChannel.setStreamHandler(this);
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding flutterPluginBinding) {
        channel = null;
        discoveryEventChannel = null;
        context = null;

        try {
            if (conn != null) {
                conn.close();
                conn = null;
            }
        } catch (Exception e) {
            Log.e("ZSDK", e.getLocalizedMessage(), e);
        }
    }

}
