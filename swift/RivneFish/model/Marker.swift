//
//  Marker.swift
//  RivneFish
//
//  Created by akyryl on 06/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import Foundation

let kMarkerIDKey = "marker_id"
let kLatKey = "lat"
let kLonKey = "lng"

class Marker {

    var markerID: NSNumber
    var lat: Float
    var lon: Float

    init(dict: NSDictionary)
    {
        markerID = dict[kMarkerIDKey] as! NSNumber
        lat = dict[kLatKey] as! Float
        lon = dict[kLonKey] as! Float

        // TODO: read all other data
    }
}
