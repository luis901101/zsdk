//
//  Cause.swift
//  zsdk
//
//  Created by Luis on 1/9/20.
//

import UIKit

enum Cause: String, CaseIterable {
    case PARTIAL_FORMAT_IN_PROGRESS = "PARTIAL_FORMAT_IN_PROGRESS"
    case HEAD_COLD = "HEAD_COLD"
    case HEAD_OPEN = "HEAD_OPEN"
    case HEAD_TOOHOT = "HEAD_TOOHOT"
    case PAPER_OUT = "PAPER_OUT"
    case RIBBON_OUT = "RIBBON_OUT"
    case RECEIVE_BUFFER_FULL = "RECEIVE_BUFFER_FULL"
    case UNKNOWN = "UNKNOWN"
}
