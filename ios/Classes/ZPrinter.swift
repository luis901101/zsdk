//
//  ZPrinter.swift
//  zsdk
//
//  Created by Luis on 1/9/20.
//

import UIKit
import Flutter

class ZPrinter: NSObject {
    let channel: FlutterMethodChannel
    let result: FlutterResult
    let printerConf: PrinterConf

    let PRINTER_LANGUAGES_CONF_KEY = "device.languages"
    let ZPL_LANGUAGE_VALUE = "hybrid_xml_zpl"
    let DEFAULT_ZPL_TCP_PORT = 9100
    
    init(channel: FlutterMethodChannel, result: @escaping FlutterResult, printerConf: PrinterConf?) {
        self.channel = FlutterMethodChannel()
        self.result = result
        self.printerConf = printerConf ?? PrinterConf()
    }
    
    private func initValues(connection: ZebraPrinterConnection) {
        printerConf.initValues(connection: connection)
    }
    
    func backgroundThread(_ delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async() {
            background?()

//            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
//            dispatch_after(popTime, dispatch_get_main_queue()) {
//                completion?()
//            }
        }
    }
    
    public func printZplOverTCPIP(filePath: String, address: String, port: Int?) {
        backgroundThread(background: {

//            if(!new File(filePath).exists()) throw new FileNotFoundException("The file: "+ filePath +"doesn't exist");
            
            let tcpPort = port ?? self.DEFAULT_ZPL_TCP_PORT;

            let connection = TcpPrinterConnection(address: address, andWithPort: tcpPort)
            connection?.open()

            do {
                let printer = try ZebraPrinterFactory.getInstance(connection)
                if (self.isReadyToPrint(printer)) {
                    self.initValues(connection: connection!);
                    try printer.getFileUtil()?.sendFileContents(filePath)
                    DispatchQueue.main.async {
                        self.result(true)
                    }
                } else {
                    let printerErrorDetails = PrinterErrorDetails(statusInfo: self.getStatusInfo(printer), message: "Printer is not ready");
                    DispatchQueue.main.async {
                        self.result(FlutterError(code: ErrorCode.PRINTER_ERROR.rawValue, message: printerErrorDetails.message, details: printerErrorDetails.toMap()))
                    }
                }

            } catch {
                DispatchQueue.main.async {
                    self.result(FlutterError(code: ErrorCode.EXCEPTION.rawValue, message: "Unknown error", details: nil))
                }
            }
            connection?.close();
        })
    }
    
    /* Sees if the printer is ready to print */
    public func isReadyToPrint(_ printer: ZebraPrinter) -> Bool {
        do {
            return try printer.getCurrentStatus().isReadyToPrint;
        } catch {/* Do Nothing */}
        return false;
    }
    
    /* Get printer status and cause in order to know when printer is not ready why is not ready*/
    public func getStatusInfo(_ printer: ZebraPrinter) -> StatusInfo {
        var status = Status.UNKNOWN
        var cause = Cause.UNKNOWN
        do {
            let printerStatus = try printer.getCurrentStatus();

            if(printerStatus.isPaused) {status = Status.PAUSED}
            if(printerStatus.isReadyToPrint) {status = Status.READY_TO_PRINT}

            if(printerStatus.isPartialFormatInProgress) {cause = Cause.PARTIAL_FORMAT_IN_PROGRESS}
            if(printerStatus.isHeadCold) {cause = Cause.HEAD_COLD}
            if(printerStatus.isHeadOpen) {cause = Cause.HEAD_OPEN}
            if(printerStatus.isHeadTooHot) {cause = Cause.HEAD_TOOHOT}
            if(printerStatus.isPaperOut) {cause = Cause.PAPER_OUT}
            if(printerStatus.isRibbonOut) {cause = Cause.RIBBON_OUT}
            if(printerStatus.isReceiveBufferFull) {cause = Cause.RECEIVE_BUFFER_FULL}

        } catch { /* Do Nothing */ }
        return StatusInfo(status: status, cause: cause);
    }
    
    /*
     * This method implements best practices to check the language of the printer and set the language of the printer to ZPL.
     * @return printer
     * @throws ConnectionException
     */
    public func changePrinterLanguage(connection: ZebraPrinterConnection, newLanguage: String?) throws {
        if(!connection.isConnected()) {connection.open()}
        let language = newLanguage ?? ZPL_LANGUAGE_VALUE
        let printerLanguage = try SGD.get(PRINTER_LANGUAGES_CONF_KEY, withPrinterConnection: (connection as! NSObjectProtocol & ZebraPrinterConnection))
        if(printerLanguage != language) {
            try SGD.set(PRINTER_LANGUAGES_CONF_KEY, withValue: language, andWithPrinterConnection: (connection as! NSObjectProtocol & ZebraPrinterConnection))
        }
    }
}
