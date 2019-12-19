package com.plugin.flutter.zsdk;

import android.content.Context;
import android.graphics.pdf.PdfRenderer;
import android.net.Uri;
import android.os.ParcelFileDescriptor;

import com.zebra.sdk.comm.Connection;
import com.zebra.sdk.comm.ConnectionException;
import com.zebra.sdk.comm.TcpConnection;
import com.zebra.sdk.printer.SGD;
import com.zebra.sdk.printer.ZebraPrinter;
import com.zebra.sdk.printer.ZebraPrinterFactory;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * Created by luis901101 on 2019-12-18.
 */
public class ZPdfPrinter extends ZPrinter
{
    public ZPdfPrinter(Context context, MethodChannel channel, Result result)
    {
        super(context, channel, result);
    }

    @Override
    void printPdfOverTCPIP(final String filePath, final String address, final Integer port) {
        new Thread(() -> {
            try
            {
                if(!new File(filePath).exists()) throw new FileNotFoundException("The file: "+ filePath +"doesn't exist");
                int tcpPort = port != null ? port : TcpConnection.DEFAULT_ZPL_TCP_PORT;
                Connection connection = new TcpConnection(address, tcpPort);

                try {
                    connection.open();
                    ZebraPrinter printer = ZebraPrinterFactory.getInstance(connection);

//                    printer.printConfigurationLabel();
////                    printer.sendFileContents(filePath);
////                    printer.printImage(filePath, 0, 0);
//
//                    String[] fileNames = printer.retrieveFileNames();
//                    for (String filename : fileNames) {
//                        System.out.println(filename);
//                    }
//                    handler.post(() -> result.success(true));



                    boolean isReady = isReady(printer);
                    String scale = scalePrint(connection, filePath);

                    SGD.SET("apl.settings", scale, connection);

                    if (isReady) {
                        printer.sendFileContents(filePath);
                    } else {
                        handler.post(() -> result.error("Printer is not ready to print", null, null));
                    }

                } catch (Exception e) {
                    throw e;
                } finally {
                    connection.close();
                }
            }
            catch(Exception e)
            {
                e.printStackTrace();
                handler.post(() -> result.error(e.toString(), null, null));
            }
        }).start();
    }

    // Takes the size of the pdf and the printer's maximum size and scales the file down
    private String scalePrint (Connection connection, String filePath) throws Exception
    {
        int fileWidth = getPageWidth(filePath);
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

    // Returns the width of the pdf page in inches for scaling later
    // PdfRenderer is only available for devices running Android Lollipop or newer
    private Integer getPageWidth(String filePath) throws IOException {
        final ParcelFileDescriptor pfdPdf = context.getContentResolver()
                .openFileDescriptor(Uri.parse("file://" + filePath), "r");
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            PdfRenderer pdf = new PdfRenderer(pfdPdf);
            PdfRenderer.Page page = pdf.openPage(0);
            int pixWidth = page.getWidth();
            int inWidth = pixWidth / 72;
            return inWidth;
        }
        return null;
    }
}
