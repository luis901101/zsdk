package com.plugin.flutter.zsdk;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by luis901101 on 2020-01-07.
 */
public class PrinterErrorDetails
{
    final StatusInfo statusInfo;
    final String message;

    public PrinterErrorDetails(StatusInfo statusInfo, String message)
    {
        this.statusInfo = statusInfo != null ? statusInfo : new StatusInfo(Status.UNKNOWN, Cause.UNKNOWN);
        this.message = message;
    }

    Map toMap() {
        Map map = new HashMap();
        map.put("statusInfo", statusInfo.toMap());
        map.put("message", message);
        return map;
    }
}
