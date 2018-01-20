//
//  GMMarkerAnnotation.swift
//  RivneFish
//
//  Created by Anatoliy Kyryliuk on 10/24/15.
//  Copyright © 2015 rivnefish. All rights reserved.
//

// Proxy for GClustering library

class GMarker: NSObject, GClusterItem {
    let placeModel: Place
    
    var marker: GMSMarker!
    var position: CLLocationCoordinate2D

    init(placeModel: Place) {
        self.placeModel = placeModel
        position = CLLocationCoordinate2D(latitude: CLLocationDegrees(placeModel.lat), longitude: CLLocationDegrees(placeModel.lon))

        let marker: GMSMarker = GMSMarker()
        marker.icon = UIImage(named: "marker")
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.appearAnimation = .pop
        marker.userData = placeModel
        marker.position = position
        self.marker = marker
    }
}
