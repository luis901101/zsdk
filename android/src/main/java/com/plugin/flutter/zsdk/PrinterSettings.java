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
    /** Fields name */
    public static final String FIELD_DARKNESS = "darkness";
    public static final String FIELD_PRINT_SPEED = "printSpeed";
    public static final String FIELD_TEAR_OFF = "tearOff";
    public static final String FIELD_MEDIA_TYPE = "mediaType";
    public static final String FIELD_PRINT_METHOD = "printMethod";
    public static final String FIELD_PRINT_WIDTH = "printWidth";
    public static final String FIELD_LABEL_LENGTH = "labelLength";
    public static final String FIELD_LABEL_LENGTH_MAX = "labelLengthMax";
    public static final String FIELD_ZPL_MODE = "zplMode";
    public static final String FIELD_POWER_UP_ACTION = "powerUpAction";
    public static final String FIELD_HEAD_CLOSE_ACTION = "headCloseAction";
    public static final String FIELD_LABEL_TOP = "labelTop";
    public static final String FIELD_LEFT_POSITION = "leftPosition";
    public static final String FIELD_PRINT_MODE = "printMode";
    public static final String FIELD_REPRINT_MODE = "reprintMode";
    public static final String FIELD_PRINTER_MODEL_NAME = "printerModelName";
    public static final String FIELD_DEVICE_FRIENDLY_NAME = "deviceFriendlyName";
    public static final String FIELD_FIRMWARE = "firmware";
    public static final String FIELD_LINK_OS_VERSION = "linkOSVersion";
    public static final String FIELD_PRINTER_DPI = "printerDpi";

    /** Writable settings */
    private String darkness;
    private String printSpeed;
    private String tearOff;
    private String mediaType;
    private String printMethod;
    private String printWidth;
    private String labelLength;
    private String labelLengthMax;
    private String zplMode;
    private String powerUpAction;
    private String headCloseAction;
    private String labelTop;
    private String leftPosition;
    private String printMode;
    private String reprintMode;

    /** Read only settings */
    private final String printerModelName;
    private final String deviceFriendlyName;
    private final String firmware;
    private final String linkOSVersion;
    private final String printerDpi;

    private static String getValue(Object argument) {
        return argument != null ?  String.valueOf(argument) : null;
    }

    public PrinterSettings(Map arguments)
    {
        this(
            getValue(arguments != null ? arguments.get(FIELD_PRINTER_MODEL_NAME) : null),
            getValue(arguments != null ? arguments.get(FIELD_DEVICE_FRIENDLY_NAME) : null),
            getValue(arguments != null ? arguments.get(FIELD_FIRMWARE) : null),
            getValue(arguments != null ? arguments.get(FIELD_LINK_OS_VERSION) : null),
            getValue(arguments != null ? arguments.get(FIELD_PRINTER_DPI) : null)
        );
        if(arguments == null) arguments = new HashMap();
        darkness = getValue(arguments.get(FIELD_DARKNESS));
        printSpeed = getValue(arguments.get(FIELD_PRINT_SPEED));
        tearOff = getValue(arguments.get(FIELD_TEAR_OFF));
        mediaType = getValue(arguments.get(FIELD_MEDIA_TYPE));
        printMethod = getValue(arguments.get(FIELD_PRINT_METHOD));
        printWidth = getValue(arguments.get(FIELD_PRINT_WIDTH));
        labelLength = getValue(arguments.get(FIELD_LABEL_LENGTH));
        labelLengthMax = getValue(arguments.get(FIELD_LABEL_LENGTH_MAX));
        zplMode = getValue(arguments.get(FIELD_ZPL_MODE));
        powerUpAction = getValue(arguments.get(FIELD_POWER_UP_ACTION));
        headCloseAction = getValue(arguments.get(FIELD_HEAD_CLOSE_ACTION));
        labelTop = getValue(arguments.get(FIELD_LABEL_TOP));
        leftPosition = getValue(arguments.get(FIELD_LEFT_POSITION));
        printMode = getValue(arguments.get(FIELD_PRINT_MODE));
        reprintMode = getValue(arguments.get(FIELD_REPRINT_MODE));
    }

    public PrinterSettings(String printerModelName, String deviceFriendlyName, String firmware,
                           String linkOSVersion, String printerDpi)
    {
        this.printerModelName = printerModelName;
        this.deviceFriendlyName = deviceFriendlyName;
        this.firmware = firmware;
        this.linkOSVersion = linkOSVersion;
        this.printerDpi = printerDpi;
    }

    public void apply(Connection connection){
        if(connection != null) {
            try {
                if(!connection.isConnected()) connection.open();
                if(darkness != null && !darkness.isEmpty()) SGD.SET(SGDParams.KEY_DARKNESS, darkness, connection);
                if(printSpeed != null && !printSpeed.isEmpty()) SGD.SET(SGDParams.KEY_PRINT_SPEED, printSpeed, connection);
                if(tearOff != null && !tearOff.isEmpty()) SGD.SET(SGDParams.KEY_TEAR_OFF, tearOff, connection);
                if(mediaType != null && !mediaType.isEmpty()) SGD.SET(SGDParams.KEY_MEDIA_TYPE, mediaType, connection);
                if(printMethod != null && !printMethod.isEmpty()) SGD.SET(SGDParams.KEY_PRINT_METHOD, printMethod, connection);
                if(printWidth != null && !printWidth.isEmpty()) SGD.SET(SGDParams.KEY_PRINT_WIDTH, printWidth, connection);
                if(labelLength != null && !labelLength.isEmpty()) SGD.SET(SGDParams.KEY_LABEL_LENGTH, labelLength, connection);
                if(labelLengthMax != null && !labelLengthMax.isEmpty()) SGD.SET(SGDParams.KEY_LABEL_LENGTH_MAX, labelLengthMax, connection);
                if(zplMode != null && !zplMode.isEmpty()) SGD.SET(SGDParams.KEY_ZPL_MODE, zplMode, connection);
                if(powerUpAction != null && !powerUpAction.isEmpty()) SGD.SET(SGDParams.KEY_POWER_UP_ACTION, powerUpAction, connection);
                if(headCloseAction != null && !headCloseAction.isEmpty()) SGD.SET(SGDParams.KEY_HEAD_CLOSE_ACTION, headCloseAction, connection);
                if(labelTop != null && !labelTop.isEmpty()) SGD.SET(SGDParams.KEY_LABEL_TOP, labelTop, connection);
                if(leftPosition != null && !leftPosition.isEmpty()) SGD.SET(SGDParams.KEY_LEFT_POSITION, leftPosition, connection);
                if(printMode != null && !printMode.isEmpty()) SGD.SET(SGDParams.KEY_PRINT_MODE, printMode, connection);
                if(reprintMode != null && !reprintMode.isEmpty()) SGD.SET(SGDParams.KEY_REPRINT_MODE, reprintMode, connection);
            }
            catch(Exception e) {
                e.printStackTrace();
            }
        }
    }

    Map toMap() {
        Map map = new HashMap();
        map.put(FIELD_DARKNESS, darkness);
        map.put(FIELD_PRINT_SPEED, printSpeed);
        map.put(FIELD_TEAR_OFF, tearOff);
        map.put(FIELD_MEDIA_TYPE, mediaType);
        map.put(FIELD_PRINT_METHOD, printMethod);
        map.put(FIELD_PRINT_WIDTH, printWidth);
        map.put(FIELD_LABEL_LENGTH, labelLength);
        map.put(FIELD_LABEL_LENGTH_MAX, labelLengthMax);
        map.put(FIELD_ZPL_MODE, zplMode);
        map.put(FIELD_POWER_UP_ACTION, powerUpAction);
        map.put(FIELD_HEAD_CLOSE_ACTION, headCloseAction);
        map.put(FIELD_LABEL_TOP, labelTop);
        map.put(FIELD_LEFT_POSITION, leftPosition);
        map.put(FIELD_PRINT_MODE, printMode);
        map.put(FIELD_REPRINT_MODE, reprintMode);
        map.put(FIELD_PRINTER_MODEL_NAME, printerModelName);
        map.put(FIELD_DEVICE_FRIENDLY_NAME, deviceFriendlyName);
        map.put(FIELD_FIRMWARE, firmware);
        map.put(FIELD_LINK_OS_VERSION, linkOSVersion);
        map.put(FIELD_PRINTER_DPI, printerDpi);
        return map;
    }

    public static PrinterSettings get(Connection connection){
        PrinterSettings settings = null;

        if(connection != null) {
            try {
                if(!connection.isConnected()) connection.open();
                settings = new PrinterSettings(
                    SGD.GET(SGDParams.KEY_PRINTER_MODEL_NAME, connection),
                    SGD.GET(SGDParams.KEY_DEVICE_FRIENDLY_NAME, connection),
                    SGD.GET(SGDParams.KEY_FIRMWARE, connection),
                    SGD.GET(SGDParams.KEY_LINK_OS_VERSION, connection),
                    SGD.GET(SGDParams.KEY_PRINTER_DPI, connection)
                );
                settings.darkness = SGD.GET(SGDParams.KEY_DARKNESS, connection);
                settings.printSpeed = SGD.GET(SGDParams.KEY_PRINT_SPEED, connection);
                settings.tearOff = SGD.GET(SGDParams.KEY_TEAR_OFF, connection);
                settings.mediaType = SGD.GET(SGDParams.KEY_MEDIA_TYPE, connection);
                settings.printMethod = SGD.GET(SGDParams.KEY_PRINT_METHOD, connection);
                settings.printWidth = SGD.GET(SGDParams.KEY_PRINT_WIDTH, connection);
                settings.labelLength = SGD.GET(SGDParams.KEY_LABEL_LENGTH, connection);
                settings.labelLengthMax = SGD.GET(SGDParams.KEY_LABEL_LENGTH_MAX, connection);
                settings.zplMode = SGD.GET(SGDParams.KEY_ZPL_MODE, connection);
                settings.powerUpAction = SGD.GET(SGDParams.KEY_POWER_UP_ACTION, connection);
                settings.headCloseAction = SGD.GET(SGDParams.KEY_HEAD_CLOSE_ACTION, connection);
                settings.labelTop = SGD.GET(SGDParams.KEY_LABEL_TOP, connection);
                settings.leftPosition = SGD.GET(SGDParams.KEY_LEFT_POSITION, connection);
                settings.printMode = SGD.GET(SGDParams.KEY_PRINT_MODE, connection);
                settings.reprintMode = SGD.GET(SGDParams.KEY_REPRINT_MODE, connection);
            }
            catch(Exception e) {
                e.printStackTrace();
            }
        }
        return settings;
    }
}