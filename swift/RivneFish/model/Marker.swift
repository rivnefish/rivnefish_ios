//
//  Marker.swift
//  RivneFish
//
//  Created by akyryl on 06/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import Foundation

let kMarkerIDKey = "marker_id"

class Marker {

    var markerID: NSNumber

    init(dict: NSDictionary)
    {
        markerID = dict[kMarkerIDKey] as! NSNumber

        // TODO: read all other data
    }
}
