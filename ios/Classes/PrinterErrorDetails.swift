//
//  PrinterErrorDetails.swift
//  zsdk
//
//  Created by Luis on 1/9/20.
//

import UIKit

class PrinterErrorDetails: NSObject {
    let statusInfo: StatusInfo
    public let message: String

    init(statusInfo: StatusInfo, message: String) {
        self.statusInfo = statusInfo
        self.message = message
    }

    public func toMap() -> Dictionary<String, Any> {
        var map = Dictionary<String, Any>();
        map["statusInfo"] = statusInfo.toMap()
        map["message"] = message
        return map;
    }
}
