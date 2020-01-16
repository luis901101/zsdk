package com.plugin.flutter.zsdk;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by luis901101 on 2020-01-07.
 */
public class StatusInfo
{
    public Status status;
    public Cause cause;

    public StatusInfo(Status status, Cause cause)
    {
        this.status = status;
        this.cause = cause;
    }

    Map toMap() {
        Map map = new HashMap();
        map.put("status", status.name());
        map.put("cause", cause.name());
        return map;
    }
}
