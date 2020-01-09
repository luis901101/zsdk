//
//  ErrorCode.swift
//  zsdk
//
//  Created by Luis on 1/9/20.
//

import UIKit

enum ErrorCode: String, CaseIterable {
    case EXCEPTION = "EXCEPTION"
    case PRINTER_ERROR = "PRINTER_ERROR"
    case UNKNOWN = "UNKNOWN"
    
    public static func getValueOfName(name: String) -> ErrorCode {
        if(name == EXCEPTION.rawValue) {return EXCEPTION}
        if(name == PRINTER_ERROR.rawValue) {return PRINTER_ERROR}
        if(name == UNKNOWN.rawValue) {return UNKNOWN}
        return UNKNOWN
    }
}
