//
//  Settings.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 20/12/2016.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import Foundation
import MapKit

class Settings {
    static let kMapTypeKey = "MapType"

    let defaults: UserDefaults
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    var currentMapType: MKMapType {
        get {
            let raw = defaults.integer(forKey: Settings.kMapTypeKey)
            return MKMapType(rawValue: UInt(raw)) ?? MKMapType.standard
        }
        set {
            defaults.set(newValue.rawValue, forKey: Settings.kMapTypeKey)
        }
    }
}
