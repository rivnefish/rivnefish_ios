//
//  PlaceFish.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 23/10/2016.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class PlaceFish: NSObject, NSCoding {
    static let kIdKey = "id"
    static let kPlaceIdKey = "place_id"
    static let kFishIdKey = "fish_id"
    static let kAvgWeightKey = "weight_avg"
    static let kMaxWeightKey = "weight_max"
    static let kAmountKey = "amount"
    static let kNotesKey = "notes"

    var id: Int?
    var placeId: Int?
    var fishId: Int?
    var avgWeight: Int?
    var maxWeight: Int?
    var amount: Int?
    var notes: String?

    init?(dict: Dictionary<String, Any>)
    {
        id = dict[PlaceFish.kIdKey] as? Int
        placeId = dict[PlaceFish.kPlaceIdKey] as? Int
        fishId = dict[PlaceFish.kFishIdKey] as? Int
        if fishId == nil {
            return nil
        }
        avgWeight = dict[PlaceFish.kAvgWeightKey] as? Int
        maxWeight = dict[PlaceFish.kMaxWeightKey] as? Int
        amount = dict[PlaceFish.kAmountKey] as? Int
        notes = dict[PlaceFish.kNotesKey] as? String
    }

    required init(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey: PlaceFish.kIdKey) as? Int
        placeId = decoder.decodeObject(forKey: PlaceFish.kPlaceIdKey) as? Int
        fishId = decoder.decodeObject(forKey: PlaceFish.kFishIdKey) as? Int
        avgWeight = decoder.decodeObject(forKey: PlaceFish.kAvgWeightKey) as? Int
        maxWeight = decoder.decodeObject(forKey: PlaceFish.kMaxWeightKey) as? Int
        amount = decoder.decodeObject(forKey: PlaceFish.kAmountKey) as? Int
        notes = decoder.decodeObject(forKey: PlaceFish.kNotesKey) as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PlaceFish.kIdKey)
        aCoder.encode(placeId, forKey: PlaceFish.kPlaceIdKey)
        aCoder.encode(fishId, forKey: PlaceFish.kFishIdKey)
        aCoder.encode(avgWeight, forKey: PlaceFish.kAvgWeightKey)
        aCoder.encode(maxWeight, forKey: PlaceFish.kMaxWeightKey)
        aCoder.encode(amount, forKey: PlaceFish.kAmountKey)
        aCoder.encode(notes, forKey: PlaceFish.kNotesKey)
    }
}
