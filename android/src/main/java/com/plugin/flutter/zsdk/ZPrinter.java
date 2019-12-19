package com.plugin.flutter.zsdk;

import android.content.Context;
import android.os.Handler;

import com.zebra.sdk.comm.Connection;
import com.zebra.sdk.comm.ConnectionException;
import com.zebra.sdk.comm.TcpConnection;
import com.zebra.sdk.printer.PrinterStatus;
import com.zebra.sdk.printer.ZebraPrinter;
import com.zebra.sdk.printer.ZebraPrinterFactory;
import com.zebra.sdk.util.internal.FileUtilities;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * Created by luis901101 on 2019-12-18.
 */
public abstract class ZPrinter
{
    protected Context context;
    protected MethodChannel channel;
    protected Result result;
    protected final Handler handler = new Handler();

    public ZPrinter(Context context, MethodChannel channel, Result result)
    {
        this.context = context;
        this.channel = channel;
        this.result = result;
    }

    void printPdfOverTCPIP(final String filePath, final String address, final Integer port) {}

    // Sees if the printer is ready to print
    public boolean isReady(ZebraPrinter printer) {
        try {
            return printer.getCurrentStatus().isReadyToPrint;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
