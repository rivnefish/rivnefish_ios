//
//  Settings.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 20/12/2016.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import Foundation

enum MapType: Int {
    case normal = 0
    case hyblid

    var gmType: GMSMapViewType {
        switch self {
        case .normal:
            return kGMSTypeNormal
        case .hyblid:
            return kGMSTypeHybrid
        }
    }
}

class Settings {
    static let kMapTypeKey = "MapType"

    let defaults: UserDefaults
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    var currentMapType: MapType {
        get {
            let raw = defaults.integer(forKey: Settings.kMapTypeKey)
            if let type = MapType(rawValue: raw) {
                return type
            } else {
                return .normal
            }
        }
        set {
            defaults.set(newValue.rawValue, forKey: Settings.kMapTypeKey)
        }
    }
}
