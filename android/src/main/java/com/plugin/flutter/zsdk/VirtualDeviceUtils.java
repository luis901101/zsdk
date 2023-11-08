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
    * This printMethod implements best practices to check the language of the printer and set the language of the printer to ZPL.
    */
   public static void changeVirtualDevice(Connection connection, String virtualDevice) throws ConnectionException {
      if(TextUtils.isEmpty(virtualDevice)) return;
      if(connection == null) return;
      if(!connection.isConnected()) connection.open();

      final String currentVirtualDevice = SGD.GET(SGDParams.KEY_VIRTUAL_DEVICE, connection);
      if(TextUtils.isEmpty(currentVirtualDevice) || !virtualDevice.equals(currentVirtualDevice)) {
         SGD.SET(SGDParams.KEY_VIRTUAL_DEVICE, virtualDevice, connection);
         reboot(connection);
      }
   }

   private static void reboot(Connection connection) {
      try {
         if(!connection.isConnected()) connection.open();
         // Another way would be using the following ZPL command:
         // connection.write("^XA^JUS^XZ".getBytes());
         ZebraPrinter printer = ZebraPrinterFactory.getInstance(connection);
         printer.reset();
         connection.close();
      } catch (ConnectionException e) {
         e.printStackTrace();
      } catch (ZebraPrinterLanguageUnknownException e1) {
         e1.printStackTrace();
      } catch(Exception e) {
         e.printStackTrace();
      }
   }
}
