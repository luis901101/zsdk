package com.plugin.flutter.zsdk;

import android.os.Handler;

import com.zebra.sdk.printer.discovery.DiscoveredPrinter;
import com.zebra.sdk.printer.discovery.DiscoveryHandler;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class ZsdkDiscoveryHandler implements DiscoveryHandler {

    private EventChannel.EventSink discoveryEventSink;
    private MethodChannel.Result result;
    private Handler handler;
    private String macAddress;

    private Map<String, String> printers = new HashMap<>();

    private static Logger logger = Logger.getLogger(ZsdkDiscoveryHandler.class.getCanonicalName());

    ZsdkDiscoveryHandler(String macAddress, Handler handler, MethodChannel.Result result, EventChannel.EventSink discoveryEventSink) {
        this.macAddress = macAddress;
        this.handler = handler;
        this.result = result;
        this.discoveryEventSink = discoveryEventSink;

        if (this.discoveryEventSink != null) {
            handler.post(() -> discoveryEventSink.success(printers));
        } else {
            logger.warning("Can't init discoveryEventSink for bluetooth discovery...");
        }
    }

    public void foundPrinter(DiscoveredPrinter printer) {
        if (macAddress != null && macAddress.equalsIgnoreCase(printer.address)) {
            printers.clear();
            printers.put(printer.address, printer.getDiscoveryDataMap().get("FRIENDLY_NAME"));
            this.discoveryFinished();
        } else {
            printers.put(printer.address, printer.getDiscoveryDataMap().get("FRIENDLY_NAME"));
            if (discoveryEventSink != null) {
                handler.post(() -> discoveryEventSink.success(printers));
            } else {
                logger.warning("Can't publish discover result to discoveryEventSink! Event sink not initialized...");
            }
        }
    }

    public void discoveryFinished() {
        if (discoveryEventSink != null) {
            handler.post(() ->
                    discoveryEventSink.success(printers)
            );
        } else {
            logger.warning("Can't publish discover result to discoveryEventSink! Event sink not initialized...");
        }
        handler.post(() -> result.success(printers));
        logger.info("Discovered " + printers.size() + " printers.");
    }

    public void discoveryError(String message) {
        if (discoveryEventSink != null) {
            handler.post(() -> discoveryEventSink.error("zebraSdkDiscoveryError", message, null));
        }

        logger.severe("An error occurred during discovery : " + message);
    }
}
