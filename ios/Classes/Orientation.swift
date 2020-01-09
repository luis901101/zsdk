//
//  Orientation.swift
//  zsdk
//
//  Created by Luis on 1/9/20.
//

import UIKit

enum Orientation: String, CaseIterable {
    case PORTRAIT = "PORTRAIT"
    case LANDSCAPE = "LANDSCAPE"

    public static func getValueOfName(name: String) -> Orientation {
        if(name == PORTRAIT.rawValue) {return PORTRAIT}
        if(name == LANDSCAPE.rawValue) {return LANDSCAPE}
        return LANDSCAPE
    }
}
