//
//  Constants.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 04/11/2016.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class Constants {
    class Network {
        static let kHostUrl = "http://new.rivnefish.com"
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
}
