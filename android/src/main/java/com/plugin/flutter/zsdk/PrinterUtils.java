package com.plugin.flutter.zsdk;

import com.zebra.sdk.comm.Connection;
import com.zebra.sdk.comm.ConnectionException;
import com.zebra.sdk.printer.ZebraPrinter;
import com.zebra.sdk.printer.ZebraPrinterFactory;
import com.zebra.sdk.printer.ZebraPrinterLanguageUnknownException;

/**
 * Created by luis901101 on 11/9/23.
 */
class PrinterUtils
{
   /**
    * Reboots the printer.
    * Returns true if successfully rebooted, false otherwise
    */
   public static boolean reboot(Connection connection) throws Exception {
      if(!connection.isConnected()) connection.open();
      // Another way would be using the following ZPL command:
      // connection.write("^XA^JUS^XZ".getBytes());
      ZebraPrinter printer = ZebraPrinterFactory.getInstance(connection);
      printer.reset();
      connection.close();
      return true;
   }
}
