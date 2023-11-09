package com.plugin.flutter.zsdk;

import android.text.TextUtils;

import com.zebra.sdk.comm.Connection;
import com.zebra.sdk.comm.ConnectionException;
import com.zebra.sdk.printer.SGD;
import com.zebra.sdk.printer.ZebraPrinter;
import com.zebra.sdk.printer.ZebraPrinterFactory;
import com.zebra.sdk.printer.ZebraPrinterLanguageUnknownException;

/**
 * Created by luis901101 on 11/7/23.
 */
class VirtualDeviceUtils {
   /**
    * This changes the printer Virtual Device only if the current Virtual Device on the printer is different that the one to be changed to and reboots the printer for the changes to take effect.
    * Returns true if the change was necessary and applied, false otherwise.
    */
   public static boolean changeVirtualDevice(Connection connection, String virtualDevice) throws Exception {
      if(TextUtils.isEmpty(virtualDevice)) return false;
      if(connection == null) return false;
      if(!connection.isConnected()) connection.open();

      final String currentVirtualDevice = SGD.GET(SGDParams.KEY_VIRTUAL_DEVICE, connection);
      if(TextUtils.isEmpty(currentVirtualDevice) || !virtualDevice.equals(currentVirtualDevice)) {
         SGD.SET(SGDParams.KEY_VIRTUAL_DEVICE, virtualDevice, connection);
         return PrinterUtils.reboot(connection);
      }
      return false;
   }
}
