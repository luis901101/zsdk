//
//  PrinterConf.swift
//  zsdk
//
//  Created by Luis on 1/9/20.
//

import UIKit

class PrinterConf: NSObject {
    let cmWidth: Double, cmHeight: Double
    var width: Int?, height: Int?
    let orientation: Orientation
    var dpi: Double?

    let PRINTER_DPI_CONF_KEY = "head.resolution.in_dpi";
    let DEFAULT_DPI = 203.0;
    
    override convenience init() {
        self.init(cmWidth: nil, cmHeight: nil, dpi: nil, orientation: nil)
    }
    
    init(cmWidth: Double?, cmHeight: Double?, dpi: Double?, orientation: Orientation?) {
        self.cmWidth = cmWidth ?? 15.20
        self.cmHeight = cmHeight ?? 7.00;
        self.dpi = (dpi ?? nil)!;
        self.orientation = orientation ?? Orientation.LANDSCAPE;
    }

    public func initValues(connection: ZebraPrinterConnection){
        if(dpi == nil) {
            do {
                if(!connection.isConnected()) {connection.open()}
                let dpiAsString = try SGD.get(PRINTER_DPI_CONF_KEY, withPrinterConnection: (connection as! NSObjectProtocol & ZebraPrinterConnection))
                dpi = Double(dpiAsString)
            }
            catch {/* Do Nothing */}
        }
        dpi = dpi ?? DEFAULT_DPI;
        width = Int(convertCmToPx(cm: cmWidth, dpi: dpi ?? 0))
        height = Int(convertCmToPx(cm: cmHeight, dpi: dpi ?? 0))
    }

    /*
     * cm the amount of centimeters to convert to pixels
     * @param cm The amount of centimeters to convert to pixels
     * @param dpi The pixel density or dots per inch to take into account in the conversion
     * @return The amount of pixels equivalent to the @param cm in the specified @param dpi
     * */
    private func convertCmToPx(cm: Double, dpi: Double) -> Double {
        let inchCm = 2.54 //One inch in centimeters
        let pixels = (dpi / inchCm) * cm
        return pixels
    }
}
