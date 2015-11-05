//
//  GMMarkerAnnotation.swift
//  RivneFish
//
//  Created by Anatoliy Kyryliuk on 10/24/15.
//  Copyright © 2015 rivnefish. All rights reserved.
//

class GMMarkerAnnotation: GMSMarker, GClusterItem {
    let myMarker: Marker
    
    var marker: GMSMarker!
    init(marker: Marker) {
        self.myMarker = marker
        super.init()

        position = CLLocationCoordinate2D(latitude: CLLocationDegrees(myMarker.lat), longitude: CLLocationDegrees(myMarker.lon))

        icon = UIImage(named: "m1")
        groundAnchor = CGPoint(x: 0.5, y: 0.5)
        appearAnimation = kGMSMarkerAnimationPop
    }
}
