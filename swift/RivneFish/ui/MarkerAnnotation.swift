//
//  MarkerAnnotation.swift
//  RivneFish
//
//  Created by akyryl on 10/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import Foundation
import MapKit

class MarkerAnnotation : NSObject, MKAnnotation {
    var marker: Marker

    init(marker: Marker) {
        self.marker = marker
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(marker.lat), longitude: CLLocationDegrees(marker.lon))
    }
    var title: String! {
        return "test"
    }
    var subtitle: String! {
        return "test"
    }

    // TODO: change in future if needed
    func pinColor() -> MKPinAnnotationColor  {
        return .Red
    }

    // TODO: implement in future if needed
    //func mapItem() -> MKMapItem {
    //}
}
