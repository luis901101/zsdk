package com.plugin.flutter.zsdk;

import com.zebra.sdk.comm.Connection;
import com.zebra.sdk.printer.SGD;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by luis901101 on 2020-01-07.
 */
public class PrinterSettings
{
    public final String
            printSpeed,
            mediaType,
            printMethod,
            tearOff,
            printWidth,
            printMode,
            labelTop,
            leftPosition,
            reprintMode,
            labelLengthMax;

    public PrinterSettings(String printSpeed, String mediaType, String printMethod, String tearOff, String printWidth, String printMode, String labelTop, String leftPosition, String reprintMode, String labelLengthMax)
    {
        this.printSpeed = printSpeed;
        this.mediaType = mediaType;
        this.printMethod = printMethod;
        this.tearOff = tearOff;
        this.printWidth = printWidth;
        this.printMode = printMode;
        this.labelTop = labelTop;
        this.leftPosition = leftPosition;
        this.reprintMode = reprintMode;
        this.labelLengthMax = labelLengthMax;
    }

    public static PrinterSettings get(Connection connection){
        PrinterSettings settings = null;

        if(connection != null) {
            try {
                if(!connection.isConnected()) connection.open();
////                ZebraPrinterLinkOs printerLinkOs = ZebraPrinterFactory.getLinkOsPrinter(connection);
////                dpi = Double.parseDouble(printerLinkOs.getSettingValue(PRINTER_DPI_CONF_KEY));
                settings = new PrinterSettings(
                    SGD.GET(SettingsParams.KEY_PRINT_SPEED, connection),
                    SGD.GET(SettingsParams.KEY_MEDIA_TYPE, connection),
                    SGD.GET(SettingsParams.KEY_PRINT_METHOD, connection),
                    SGD.GET(SettingsParams.KEY_TEAR_OFF, connection),
                    SGD.GET(SettingsParams.KEY_PRINT_WIDTH, connection),
                    SGD.GET(SettingsParams.KEY_PRINT_MODE, connection),
                    SGD.GET(SettingsParams.KEY_LABEL_TOP, connection),
                    SGD.GET(SettingsParams.KEY_LEFT_POSITION, connection),
                    SGD.GET(SettingsParams.KEY_REPRINT_MODE, connection),
                    SGD.GET(SettingsParams.KEY_LABEL_LENGTH_MAX, connection)
                );
            }
            catch(Exception e) {
                e.printStackTrace();
            }
        }
        return settings;
    }

    Map toMap() {
        Map map = new HashMap();
        map.put("printSpeed", printSpeed);
        map.put("mediaType", mediaType);
        map.put("printMethod", printMethod);
        map.put("tearOff", tearOff);
        map.put("printWidth", printWidth);
        map.put("printMode", printMode);
        map.put("labelTop", labelTop);
        map.put("leftPosition", leftPosition);
        map.put("reprintMode", reprintMode);
        map.put("labelLengthMax", labelLengthMax);
        return map;
    }
}
