package com.plugin.flutter.zsdk;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by luis901101 on 2020-01-07.
 */
public class PrinterResponse
{
    final ErrorCode errorCode;
    final StatusInfo statusInfo;
    final PrinterSettings settings;
    final String message;

    public PrinterResponse(ErrorCode errorCode, StatusInfo statusInfo, String message)
    {
        this(errorCode, statusInfo, null, message);
    }

    public PrinterResponse(ErrorCode errorCode, StatusInfo statusInfo, PrinterSettings settings, String message)
    {
        this.errorCode = errorCode != null ? errorCode : ErrorCode.UNKNOWN;
        this.statusInfo = statusInfo != null ? statusInfo : new StatusInfo(Status.UNKNOWN, Cause.UNKNOWN);
        this.settings = settings;
        this.message = message;
    }

    Map<String, Object> toMap() {
        Map<String, Object> map = new HashMap<>();
        map.put("errorCode", errorCode.name());
        map.put("statusInfo", statusInfo.toMap());
        map.put("settings", settings != null ? settings.toMap() : null);
        map.put("message", message);
        return map;
    }
}
