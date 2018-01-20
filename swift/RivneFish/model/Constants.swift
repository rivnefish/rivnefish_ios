//
//  Constants.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 04/11/2016.
//  Copyright © 2016 rivnefish. All rights reserved.
//

typealias EmptyClosure = () -> Void

class Constants {
    class Network {
        static let kHostUrl = "https://rivnefish.com"
        static let kPlacesUrl = Network.kHostUrl + "/api/v1/places"
        static let kPlacesLastChangesUrl = Network.kPlacesUrl + "/lastchanges"
        static let kFishUrl = Network.kHostUrl + "/api/v1/fish"
        static let kFishLastChangesUrl = Network.kFishUrl + "/lastchanges"
    }

    class Cache {
        static let kPlacesLastChangesKey = "PlacesLastChanges"
        static let kFishLastChangesKey = "FishLastChanges"

        static let kPlacesKey = "Places"
        static let kPlaceDetailsKey = "PlaceDetails:"
        static let kFishKey = "Fish"
    }

    class Colors {
        static let kMain = UIColor(red: 28.0 / 255.0, green: 52.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0) // #30344f
        static let kMainContrast = UIColor(red: 255 / 255, green: 180.0 / 255.0, blue: 0, alpha: 1.0) // #ffb400
    }
}
