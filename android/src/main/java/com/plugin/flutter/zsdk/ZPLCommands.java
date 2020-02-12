package com.plugin.flutter.zsdk;

/**
 * Created by luis901101 on 2020-02-11.
 */
public class ZPLCommands
{
    public static final String INIT = "^XA";
    public static final String END = "^XZ";
    public static final String SET_PRINT_WIDTH = "^PW{v1}";//v1 depends on the printer for instance ZEBRA ZD500 is up to 832 width
    public static final String SET_PRINT_SPEED = "^PR{v1}";//v1 depends on the printer for instance ZEBRA ZD500 is from 2 - 6.
}
