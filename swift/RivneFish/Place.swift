//
//  Place.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 19/10/2016.
//  Copyright © 2016 rivnefish. All rights reserved.
//

let kPlaceIDKey = "id"
let kPlaceLatKey = "lat"
let kPlaceLonKey = "lng"
let kPlaceNameKey = "name"
let kPlaceDateKey = "updated_at"


class Place: NSObject, NSCoding {
    var id: Int
    var lat: Float
    var lon: Float
    var name: String
    var date: Date?

    init(dict: NSDictionary)
    {
        id = dict[kPlaceIDKey] as! Int
        let lastStr = dict[kPlaceLatKey] as! String
        lat =  Float(lastStr)!
        let lonStr = dict[kPlaceLonKey] as! String
        lon =  Float(lonStr)!
        name = dict[kPlaceNameKey] as? String ?? ""
        if let dateStr = dict[kPlaceDateKey] as? String {
            date = Date()
        }
    }

    required init(coder decoder: NSCoder) {
        id = decoder.decodeInteger(forKey: kPlaceIDKey)
        lat = decoder.decodeFloat(forKey: kPlaceLatKey)
        lon = decoder.decodeFloat(forKey: kPlaceLonKey)
        name = decoder.decodeObject(forKey: kPlaceNameKey) as? String ?? ""
        date = decoder.decodeObject(forKey: kPlaceDateKey) as? Date
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: kPlaceIDKey)
        aCoder.encode(lat, forKey: kPlaceLatKey)
        aCoder.encode(lon, forKey: kPlaceLonKey)
        aCoder.encode(name, forKey: kPlaceNameKey)
        aCoder.encode(date, forKey: kPlaceDateKey)
    }
}
