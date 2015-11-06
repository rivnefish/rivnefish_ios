//
//  GMMarkerAnnotation.swift
//  RivneFish
//
//  Created by Anatoliy Kyryliuk on 10/24/15.
//  Copyright © 2015 rivnefish. All rights reserved.
//

// Proxy for GClustering library

class GMarker: NSObject, GClusterItem {
    let markerModel: MarkerModel
    
    var marker: GMSMarker!
    var position: CLLocationCoordinate2D

    init(markerModel: MarkerModel) {
        self.markerModel = markerModel
        position = CLLocationCoordinate2D(latitude: CLLocationDegrees(markerModel.lat), longitude: CLLocationDegrees(markerModel.lon))

        let marker: GMSMarker = GMSMarker()
        marker.icon = UIImage(named: "m1")
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.userData = markerModel
        marker.position = position
        self.marker = marker
    }
}
