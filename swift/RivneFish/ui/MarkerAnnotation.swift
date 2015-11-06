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
    var marker: MarkerModel

    var clusterAnnotation: MarkerAnnotation?
    var containedAnnotations: Array<MarkerAnnotation>?
    var innerCoordinate: CLLocationCoordinate2D

    init(marker: MarkerModel) {
        self.marker = marker
        self.containedAnnotations = Array<MarkerAnnotation>()
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

    var title: String? {
        let childsCount = self.childsCount()
        if childsCount > 0 {
            return String(childsCount + 1)
        }
        return self.marker.name
    }
    var subtitle: String? {
        let childsCount = self.childsCount()
        if childsCount > 0 {
            return String(childsCount + 1)
        }
        return self.marker.address
    }

    var containedItemsCount: Int {
        let childsCount = self.childsCount()
        if childsCount > 0 {
            return childsCount + 1
        }
        return Int(0)
    }

    func childsCount() -> Int {
        var result = 0
        if let array = self.containedAnnotations {
            result = array.count
        }
        return result
    }

    // TODO: change in future if needed
    func pinColor() -> MKPinAnnotationColor  {
        return .Red
    }

    // TODO: implement in future if needed
    //func mapItem() -> MKMapItem {
    //}
}
