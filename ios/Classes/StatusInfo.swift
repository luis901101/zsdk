//
//  StatusInfo.swift
//  zsdk
//
//  Created by Luis on 1/9/20.
//

import UIKit

class StatusInfo: NSObject {
    let status: Status
    let cause: Cause

    init(status: Status, cause: Cause) {
        self.status = status
        self.cause = cause
    }

    func toMap() -> Dictionary<String, Any> {
        var map = Dictionary<String, Any>();
        map["status"] = status.rawValue
        map["cause"] = cause.rawValue
        return map;
    }
}
