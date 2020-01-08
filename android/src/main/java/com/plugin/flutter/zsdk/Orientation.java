package com.plugin.flutter.zsdk;

/**
 * Created by luis901101 on 2020-01-07.
 */
public enum Orientation
{
    PORTRAIT,
    LANDSCAPE;

    public static Orientation getValueOfName(String name){
        if(name == null) return null;
        if(name.equals(Orientation.PORTRAIT.name())) return Orientation.PORTRAIT;
        if(name.equals(Orientation.LANDSCAPE.name())) return Orientation.LANDSCAPE;
        return null;
    }
}
