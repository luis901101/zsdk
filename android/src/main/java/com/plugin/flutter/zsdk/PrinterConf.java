package com.plugin.flutter.zsdk;

import com.zebra.sdk.comm.Connection;
import com.zebra.sdk.printer.SGD;

/**
 * Created by luis901101 on 2020-01-07.
 */
public class PrinterConf {
    private double cmWidth, cmHeight;
    private int width, height;
    private Orientation orientation;
    private Double dpi;

    public PrinterConf() {
        this(null, null, null, null);
    }
    public PrinterConf(Double cmWidth, Double cmHeight, Double dpi, Orientation orientation)
    {
        this.cmWidth = cmWidth != null ? cmWidth : 15.20;
        this.cmHeight = cmHeight != null ? cmHeight : 7.00;
        this.dpi = dpi;
        this.orientation = orientation != null ? orientation : Orientation.LANDSCAPE;
    }

    protected void init(Connection connection){
        if(dpi == null && connection != null) {
            try {
                if(!connection.isConnected()) connection.open();
//                ZebraPrinterLinkOs printerLinkOs = ZebraPrinterFactory.getLinkOsPrinter(connection);
//                dpi = Double.parseDouble(printerLinkOs.getSettingValue(PRINTER_DPI_CONF_KEY));
                dpi = Double.parseDouble(SGD.GET(SGDParams.KEY_PRINTER_DPI, connection));
            }
            catch(Exception e) {
                e.printStackTrace();
            }
        }
        if(dpi == null) dpi = SGDParams.VALUE_DPI_DEFAULT;
        width = (int) convertCmToPx(cmWidth, dpi);
        height = (int) convertCmToPx(cmHeight, dpi);
    }

    /**
     * cm the amount of centimeters to convert to pixels
     * @param cm The amount of centimeters to convert to pixels
     * @param dpi The pixel density or dots per inch to take into account in the conversion
     * @return The amount of pixels equivalent to the @param cm in the specified @param dpi
     * */
    private double convertCmToPx(double cm, double dpi) {
        final double inchCm = 2.54; //One inch in centimeters
        return (dpi / inchCm) * cm;
    }

    public int getWidth()
    {
        return width;
    }

    public int getHeight()
    {
        return height;
    }

    public Orientation getOrientation()
    {
        return orientation;
    }
}
