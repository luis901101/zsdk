package com.plugin.flutter.zsdk;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Handler;
import android.util.Log;

import com.zebra.sdk.comm.Connection;
import com.zebra.sdk.comm.ConnectionException;
import com.zebra.sdk.comm.TcpConnection;
import com.zebra.sdk.graphics.internal.ZebraImageAndroid;
import com.zebra.sdk.printer.PrinterStatus;
import com.zebra.sdk.printer.SGD;
import com.zebra.sdk.printer.ZebraPrinter;
import com.zebra.sdk.printer.ZebraPrinterFactory;
import com.zebra.sdk.printer.ZebraPrinterLinkOs;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * Created by luis901101 on 2019-12-18.
 */
public class ZPrinter
{
    protected Context context;
    protected MethodChannel channel;
    protected Result result;
    protected final Handler handler = new Handler();
    protected PrinterConf printerConf;

    public final String PRINTER_LANGUAGES_CONF_KEY = "device.languages";
    public final String ZPL_LANGUAGE_VALUE = "hybrid_xml_zpl";

    public ZPrinter(Context context, MethodChannel channel, Result result, PrinterConf printerConf)
    {
        this.context = context;
        this.channel = channel;
        this.result = result;
        this.printerConf = printerConf != null ? printerConf : new PrinterConf();
    }

    protected void init(Connection connection){
        printerConf.init(connection);
    }

    void printPdfOverTCPIP(final String filePath, final String address, final Integer port) {
        new Thread(() -> {
            try
            {
                if(!new File(filePath).exists()) throw new FileNotFoundException("The file: "+ filePath +"doesn't exist");
                int tcpPort = port != null ? port : TcpConnection.DEFAULT_ZPL_TCP_PORT;

                Connection connection = new TcpConnection(address, tcpPort);
                connection.open();

                try {
                    ZebraPrinter printer = ZebraPrinterFactory.getInstance(connection);
                    if (isReadyToPrint(printer)) {
                        init(connection);

                        List<ImageData> list = PdfUtils.getImagesFromPdf(context, filePath, printerConf.getWidth(), printerConf.getHeight(), printerConf.getOrientation(), true);
                        for(int i = 0; i < list.size(); ++i) {
                            printer.printImage(new ZebraImageAndroid(list.get(i).bitmap), 0, 0, -1, -1, false);//Prints image directly from bitmap
//                            printer.printImage(list.get(i).path, 0, 0);//Prints image from file path
                        }
                        handler.post(() -> result.success(true));
                    } else {
                        PrinterErrorDetails printerErrorDetails = new PrinterErrorDetails(
                                getStatusInfo(printer), "Printer is not ready");
                        handler.post(() -> result.error(printerErrorDetails.statusInfo.status.name(),
                                printerErrorDetails.message, printerErrorDetails.toMap()));
                    }

                } finally {
                    connection.close();
                }
            }
            catch(Exception e)
            {
                e.printStackTrace();
                handler.post(() -> result.error(null, e.toString(), null));
            }
        }).start();
    }

    void printZplOverTCPIP(final String filePath, final String address, final Integer port) {
        new Thread(() -> {
            try
            {
                if(!new File(filePath).exists()) throw new FileNotFoundException("The file: "+ filePath +"doesn't exist");
                int tcpPort = port != null ? port : TcpConnection.DEFAULT_ZPL_TCP_PORT;

                Connection connection = new TcpConnection(address, tcpPort);
                connection.open();

                try {
                    ZebraPrinter printer = ZebraPrinterFactory.getInstance(connection);
                    if (isReadyToPrint(printer)) {
                        init(connection);
                        printer.sendFileContents(filePath);
                        handler.post(() -> result.success(true));
                    } else {
                        PrinterErrorDetails printerErrorDetails = new PrinterErrorDetails(
                                getStatusInfo(printer), "Printer is not ready");
                        handler.post(() -> result.error(printerErrorDetails.statusInfo.status.name(),
                                printerErrorDetails.message, printerErrorDetails.toMap()));
                    }

                } finally {
                    connection.close();
                }
            }
            catch(Exception e)
            {
                e.printStackTrace();
                handler.post(() -> result.error(null, e.toString(), null));
            }
        }).start();
    }

    /** Sees if the printer is ready to print */
    public boolean isReadyToPrint(ZebraPrinter printer) {
        try {
            return printer.getCurrentStatus().isReadyToPrint;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Get printer status and cause in order to know when printer is not ready why is not ready*/
    public StatusInfo getStatusInfo(ZebraPrinter printer) {
        Status status = Status.UNKNOWN;
        Cause cause = Cause.UNKNOWN;
        try {
            PrinterStatus printerStatus = printer.getCurrentStatus();

            if(printerStatus.isPaused) status = Status.PAUSED;
            if(printerStatus.isReadyToPrint) status = Status.READY_TO_PRINT;

            if(printerStatus.isPartialFormatInProgress) cause = Cause.PARTIAL_FORMAT_IN_PROGRESS;
            if(printerStatus.isHeadCold) cause = Cause.HEAD_COLD;
            if(printerStatus.isHeadOpen) cause = Cause.HEAD_OPEN;
            if(printerStatus.isHeadTooHot) cause = Cause.HEAD_TOOHOT;
            if(printerStatus.isPaperOut) cause = Cause.PAPER_OUT;
            if(printerStatus.isRibbonOut) cause = Cause.RIBBON_OUT;
            if(printerStatus.isReceiveBufferFull) cause = Cause.RECEIVE_BUFFER_FULL;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return new StatusInfo(status, cause);
    }

    /**
     * This method implements best practices to check the language of the printer and set the language of the printer to ZPL.
     * @return printer
     * @throws ConnectionException
     */
    public void changePrinterLanguage(Connection connection, String language) throws ConnectionException {
        if(connection == null) return;
        if(!connection.isConnected()) connection.open();

        if(language == null) language = ZPL_LANGUAGE_VALUE;

        final String printerLanguage = SGD.GET("device.languages", connection);
        if(!printerLanguage.equals(language))
            SGD.SET(PRINTER_LANGUAGES_CONF_KEY, language, connection);
    }

    public void printAllSettings(Connection connection) throws Exception {
        if(connection == null) return;
        if(!connection.isConnected()) connection.open();
        ZebraPrinterLinkOs printerLinkOs = ZebraPrinterFactory.getLinkOsPrinter(connection);
        Map<String, String> allSettings = printerLinkOs.getAllSettingValues();
        for(Object key : allSettings.keySet())
            Log.e("allSettings", key+"--->"+allSettings.get(key));
    }

    /** Takes the size of the pdf and the printer's maximum size and scales the file down */
    private String scalePrint (Connection connection, String filePath) throws Exception
    {
        int fileWidth = PdfUtils.getPageWidth(context, filePath);
        String scale = "dither scale-to-fit";

        if (fileWidth != 0) {
            String printerModel = SGD.GET("device.host_identification",connection).substring(0,5);
            double scaleFactor;

            if (printerModel.equals("iMZ22")||printerModel.equals("QLn22")||printerModel.equals("ZD410")) {
                scaleFactor = 2.0/fileWidth*100;
            } else if (printerModel.equals("iMZ32")||printerModel.equals("QLn32")||printerModel.equals("ZQ510")) {
                scaleFactor = 3.0/fileWidth*100;
            } else if (printerModel.equals("QLn42")||printerModel.equals("ZQ520")||
                    printerModel.equals("ZD420")||printerModel.equals("ZD500")||
                    printerModel.equals("ZT220")||printerModel.equals("ZT230")||
                    printerModel.equals("ZT410")) {
                scaleFactor = 4.0/fileWidth*100;
            } else if (printerModel.equals("ZT420")) {
                scaleFactor = 6.5/fileWidth*100;
            } else {
                scaleFactor = 100;
            }

            scale = "dither scale=" + (int) scaleFactor + "x" + (int) scaleFactor;
        }

        return scale;
    }
}
