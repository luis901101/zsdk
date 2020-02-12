package com.plugin.flutter.zsdk;

/**
 * Created by luis901101 on 2020-02-10.
 */
public class SGDParams
{
    /** Settings */

    /** Writable settings */
    public static final String KEY_DARKNESS = "print.tone";
    public static final String KEY_PRINT_SPEED = "media.speed";
    public static final String KEY_TEAR_OFF = "ezpl.tear_off";
    public static final String KEY_MEDIA_TYPE = "ezpl.media_type";
    public static final String KEY_PRINT_METHOD = "ezpl.print_method";
    public static final String KEY_PRINT_WIDTH = "ezpl.print_width";
    public static final String KEY_LABEL_LENGTH = "zpl.label_length";
    public static final String KEY_LABEL_LENGTH_MAX = "ezpl.label_length_max";
    public static final String KEY_ZPL_MODE = "zpl.zpl_mode";
    public static final String KEY_POWER_UP_ACTION = "ezpl.power_up_action";
    public static final String KEY_HEAD_CLOSE_ACTION = "ezpl.head_close_action";
    public static final String KEY_LABEL_TOP = "zpl.label_top";
    public static final String KEY_LEFT_POSITION = "zpl.left_position";
    public static final String KEY_PRINT_MODE = "ezpl.print_mode";
    public static final String KEY_REPRINT_MODE = "ezpl.reprint_mode";
    public static final String KEY_PRINTER_LANGUAGES = "device.languages";

    /** Read only settings */
    public static final String KEY_PRINTER_MODEL_NAME = "ip.dhcp.vendor_class_id";
    public static final String KEY_DEVICE_FRIENDLY_NAME = "device.friendly_name";
    public static final String KEY_FIRMWARE = "appl.name";
    public static final String KEY_LINK_OS_VERSION = "appl.link_os_version";
    public static final String KEY_PRINTER_DPI = "head.resolution.in_dpi";

    /** Actions */
    public static final String KEY_MANUAL_CALIBRATION = "ezpl.manual_calibration";

    /** Values */
    public static final String VALUE_ZPL_LANGUAGE = "hybrid_xml_zpl";
    public static final double VALUE_DPI_DEFAULT = 203;
    public static final String VALUE_GET_ALL = "allcv";
}
