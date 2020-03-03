package com.plugin.flutter.zsdk;

import android.content.Context;
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
import com.zebra.sdk.util.internal.FileUtilities;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.InputStream;
import java.nio.charset.Charset;
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
    private final int MAX_TIME_OUT_FOR_READ = 5000;
    private final int TIME_TO_WAIT_FOR_MORE_DATA = 0;

    public ZPrinter(Context context, MethodChannel channel, Result result, PrinterConf printerConf)
    {
        this.context = context;
        this.channel = channel;
        this.result = result;
        this.printerConf = printerConf != null ? printerConf : new PrinterConf();
    }

    private TcpConnection newConnection(String address, int tcpPort){
        return new TcpConnection(address, tcpPort, MAX_TIME_OUT_FOR_READ, TIME_TO_WAIT_FOR_MORE_DATA);
    }

    protected void init(Connection connection){
        printerConf.init(connection);
    }

    private void onConnectionTimeOut(ConnectionException e){
        if(e != null) e.printStackTrace();
        PrinterResponse response = new PrinterResponse(ErrorCode.EXCEPTION,
                new StatusInfo(Status.UNKNOWN, Cause.NO_CONNECTION), "Connection timeout. "+e.toString());
        handler.post(() -> result.error(response.errorCode.name(), response.message, response.toMap()));
    }

    private void onException(Exception e, ZebraPrinter printer){
        if(e != null) e.printStackTrace();
        PrinterResponse response = new PrinterResponse(ErrorCode.EXCEPTION,
                getStatusInfo(printer), "Unknown exception. "+e.toString());
        handler.post(() -> result.error(response.errorCode.name(), response.message, response.toMap()));
    }

    public void doManualCalibrationOverTCPIP(final String address, final Integer port) {
        new Thread(() -> {
            Connection connection;
            ZebraPrinter printer = null;
            try
            {
                int tcpPort = port != null ? port : TcpConnection.DEFAULT_ZPL_TCP_PORT;

                connection = newConnection(address, tcpPort);
                connection.open();

                try {
                    printer = ZebraPrinterFactory.getInstance(connection);
//                    SGD.DO(SGDParams.KEY_MANUAL_CALIBRATION, null, connection);
                    printer.calibrate();
                    PrinterResponse response = new PrinterResponse(ErrorCode.SUCCESS,
                            getStatusInfo(printer), "Printer status");
                    handler.post(() -> result.success(response.toMap()));
                }
                catch(Exception e) {
                    throw e;
                }
                finally {
                    connection.close();
                }
            }
            catch(ConnectionException e)
            {
                onConnectionTimeOut(e);
            }
            catch(Exception e)
            {
                onException(e, printer);
            }
        }).start();
    }

    public void printConfigurationLabelOverTCPIP(final String address, final Integer port) {
        new Thread(() -> {
            Connection connection;
            ZebraPrinter printer = null;
            try
            {
                int tcpPort = port != null ? port : TcpConnection.DEFAULT_ZPL_TCP_PORT;

                connection = newConnection(address, tcpPort);
                connection.open();

                try {
                    printer = ZebraPrinterFactory.getInstance(connection);
                    printer.printConfigurationLabel();
                    PrinterResponse response = new PrinterResponse(ErrorCode.SUCCESS,
                            getStatusInfo(printer), "Printer status");
                    handler.post(() -> result.success(response.toMap()));
                }
                catch(Exception e) {
                    throw e;
                }
                finally {
                    connection.close();
                }
            }
            catch(ConnectionException e)
            {
                onConnectionTimeOut(e);
            }
            catch(Exception e)
            {
                onException(e, printer);
            }
        }).start();
    }

    public void checkPrinterStatusOverTCPIP(final String address, final Integer port) {
        new Thread(() -> {
            Connection connection;
            ZebraPrinter printer = null;
            try
            {
                int tcpPort = port != null ? port : TcpConnection.DEFAULT_ZPL_TCP_PORT;

                connection = newConnection(address, tcpPort);
                connection.open();

                try {
                    printer = ZebraPrinterFactory.getInstance(connection);

                    PrinterResponse response = new PrinterResponse(ErrorCode.SUCCESS,
                            getStatusInfo(printer), "Printer status");
                    handler.post(() -> result.success(response.toMap()));
                }
                catch(Exception e) {
                    throw e;
                }
                finally {
                    connection.close();
                }
            }
            catch(ConnectionException e)
            {
                onConnectionTimeOut(e);
            }
            catch(Exception e)
            {
                onException(e, printer);
            }
        }).start();
    }

    public void getPrinterSettingsOverTCPIP(final String address, final Integer port) {
        new Thread(() -> {
            Connection connection;
            ZebraPrinter printer = null;
            try
            {
                int tcpPort = port != null ? port : TcpConnection.DEFAULT_ZPL_TCP_PORT;

                connection = newConnection(address, tcpPort);
                connection.open();

                try {
                    printer = ZebraPrinterFactory.getInstance(connection);
                    PrinterSettings settings = PrinterSettings.get(connection);
                    PrinterResponse response = new PrinterResponse(ErrorCode.SUCCESS,
                            getStatusInfo(printer), settings, "Printer status");
                    handler.post(() -> result.success(response.toMap()));
                }
                catch(Exception e) {
                    throw e;
                } finally {
                    connection.close();
                }
            }
            catch(ConnectionException e)
            {
                onConnectionTimeOut(e);
            }
            catch(Exception e)
            {
                onException(e, printer);
            }
        }).start();
    }

    public void setPrinterSettingsOverTCPIP(final String address, final Integer port, final PrinterSettings settings) {
        new Thread(() -> {
            Connection connection;
            ZebraPrinter printer = null;
            try
            {
                if(settings == null) throw new NullPointerException("Settings can't be null");

                int tcpPort = port != null ? port : TcpConnection.DEFAULT_ZPL_TCP_PORT;

                connection = newConnection(address, tcpPort);
                connection.open();

                try {
                    printer = ZebraPrinterFactory.getInstance(connection);
                    settings.apply(connection);
                    PrinterSettings currentSettings = PrinterSettings.get(connection);
                    PrinterResponse response = new PrinterResponse(ErrorCode.SUCCESS,
                            getStatusInfo(printer), currentSettings, "Printer status");
                    handler.post(() -> result.success(response.toMap()));
                }catch(Exception e) {
                    throw e;
                } finally {
                    connection.close();
                }
            }
            catch(ConnectionException e)
            {
                onConnectionTimeOut(e);
            }
            catch(Exception e)
            {
                onException(e, printer);
            }
        }).start();
    }

    public void printPdfOverTCPIP(final String filePath, final String address, final Integer port) {
        new Thread(() -> {
            Connection connection;
            ZebraPrinter printer = null;
            try
            {
                if(!new File(filePath).exists()) throw new FileNotFoundException("The file: "+ filePath +"doesn't exist");
                int tcpPort = port != null ? port : TcpConnection.DEFAULT_ZPL_TCP_PORT;

                connection = newConnection(address, tcpPort);
                connection.open();

                try {
                    printer = ZebraPrinterFactory.getInstance(connection);
                    if (isReadyToPrint(printer)) {
                        init(connection);

                        List<ImageData> list = PdfUtils.getImagesFromPdf(context, filePath, printerConf.getWidth(), printerConf.getHeight(), printerConf.getOrientation(), true);
                        for(int i = 0; i < list.size(); ++i) {
                            printer.printImage(new ZebraImageAndroid(list.get(i).bitmap), 0, 0, -1, -1, false);//Prints image directly from bitmap
//                            printer.printImage(list.get(i).path, 0, 0);//Prints image from file path
                        }
                        PrinterResponse response = new PrinterResponse(ErrorCode.SUCCESS,
                                getStatusInfo(printer), "Successful print");
                        handler.post(() -> result.success(response.toMap()));
                    } else {
                        PrinterResponse response = new PrinterResponse(ErrorCode.PRINTER_ERROR,
                                getStatusInfo(printer), "Printer is not ready");
                        handler.post(() -> result.error(ErrorCode.PRINTER_ERROR.name(),
                                response.message, response.toMap()));
                    }

                }catch(Exception e) {
                    throw e;
                } finally {
                    connection.close();
                }
            }
            catch(ConnectionException e)
            {
                onConnectionTimeOut(e);
            }
            catch(Exception e)
            {
                onException(e, printer);
            }
        }).start();
    }

    public void printZplFileOverTCPIP(final String filePath, final String address, final Integer port) {
        new Thread(() -> {
            try
            {
                if(!new File(filePath).exists()) throw new FileNotFoundException("The file: "+ filePath +"doesn't exist");
                doPrintZplDataOverTCPIP(new FileInputStream(filePath), address, port);
            }
            catch(Exception e)
            {
                onException(e, null);
            }
        }).start();
    }

    public void printZplDataOverTCPIP(final String data, final String address, final Integer port) {
        if(data == null || data.isEmpty()) throw new NullPointerException("ZPL data can not be empty");
        new Thread(() -> doPrintZplDataOverTCPIP(
            new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))), address, port))
            .start();
    }

    private void doPrintZplDataOverTCPIP(final InputStream dataStream, final String address, final Integer port) {
        Connection connection;
        ZebraPrinter printer = null;
        try
        {
            if(dataStream == null) throw new NullPointerException("ZPL data can not be empty");
            int tcpPort = port != null ? port : TcpConnection.DEFAULT_ZPL_TCP_PORT;

            connection = newConnection(address, tcpPort);
            connection.open();

            try {
                printer = ZebraPrinterFactory.getInstance(connection);
                if (isReadyToPrint(printer)) {
                    init(connection);
                    changePrinterLanguage(connection, SGDParams.VALUE_ZPL_LANGUAGE);
//                    connection.write(data.getBytes()); //This would be to send zpl as a string, this fails if the string is too big
//                    printer.sendFileContents(filePath); //This would be to send zpl as a file path
                    FileUtilities.sendFileContentsInChunks(connection, dataStream);
                    PrinterResponse response = new PrinterResponse(ErrorCode.SUCCESS,
                            getStatusInfo(printer), "Successful print");
                    handler.post(() -> result.success(response.toMap()));
                } else {
                    PrinterResponse response = new PrinterResponse(ErrorCode.PRINTER_ERROR,
                            getStatusInfo(printer), "Printer is not ready");
                    handler.post(() -> result.error(ErrorCode.PRINTER_ERROR.name(),
                            response.message, response.toMap()));
                }

            }catch(Exception e) {
                throw e;
            } finally {
                connection.close();
            }
        }
        catch(ConnectionException e)
        {
            onConnectionTimeOut(e);
        }
        catch(Exception e)
        {
            onException(e, printer);
        }
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
            if(printerStatus.isHeadTooHot) cause = Cause.HEAD_TOO_HOT;
            if(printerStatus.isPaperOut) cause = Cause.PAPER_OUT;
            if(printerStatus.isRibbonOut) cause = Cause.RIBBON_OUT;
            if(printerStatus.isReceiveBufferFull) cause = Cause.RECEIVE_BUFFER_FULL;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return new StatusInfo(status, cause);
    }

    /**
     * This printMethod implements best practices to check the language of the printer and set the language of the printer to ZPL.
     */
    public void changePrinterLanguage(Connection connection, String language) throws ConnectionException {
        if(connection == null) return;
        if(!connection.isConnected()) connection.open();

        if(language == null) language = SGDParams.VALUE_ZPL_LANGUAGE;

        final String printerLanguage = SGD.GET(SGDParams.KEY_PRINTER_LANGUAGES, connection);
        if(!printerLanguage.equals(language))
            SGD.SET(SGDParams.KEY_PRINTER_LANGUAGES, language, connection);
    }

    public void printAllValues(Connection connection) throws Exception {
        Log.e("allSettingsValues", SGD.GET(SGDParams.VALUE_GET_ALL, connection));
    }

    public void printAllSettings(Connection connection) throws Exception {
        if(connection == null) return;
        if(!connection.isConnected()) connection.open();
        ZebraPrinterLinkOs printerLinkOs = ZebraPrinterFactory.getLinkOsPrinter(connection);
        Map<String, String> allSettings = printerLinkOs.getAllSettingValues();
        for(Object key : allSettings.keySet())
            Log.e("paramSetting", key+"--->"+allSettings.get(key));
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
