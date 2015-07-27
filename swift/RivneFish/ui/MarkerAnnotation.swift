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

    var clusterAnnotation: MarkerAnnotation?
    var containedAnnotations: NSArray?
    var innerCoordinate: CLLocationCoordinate2D

    init(marker: Marker) {
        self.marker = marker
        self.containedAnnotations = NSArray()
        self.innerCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(marker.lat), longitude: CLLocationDegrees(marker.lon))
    }

    dynamic var coordinate: CLLocationCoordinate2D {
        get {
            return innerCoordinate
        }
        set {
            self.innerCoordinate = newValue
        }
    }

    var title: String! {
        if let array = containedAnnotations {
            return String(array.count + 1)
        }
        return "0"
    }
    var subtitle: String! {
        return "test"
    }

    var containedItemsCount: Int {
        if let array = containedAnnotations {
            return array.count + 1
        }
        return Int(0)
    }

    // TODO: change in future if needed
    func pinColor() -> MKPinAnnotationColor  {
        return .Red
    }

    // TODO: implement in future if needed
    //func mapItem() -> MKMapItem {
    //}
}
