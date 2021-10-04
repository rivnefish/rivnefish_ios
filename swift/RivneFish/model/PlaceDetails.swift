//
//  Marker.swift
//  RivneFish
//
//  Created by akyryl on 06/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import Foundation

let kMarkerIDKey = "id"
let kLatKey = "lat"
let kLonKey = "lng"
let kNameKey = "name"

let kAreaKey = "area"
let kDepthMaxKey = "depth_max"
let kDepthAvgKey = "depth_avg"

let kPermitKey = "permit"
let kTimeToFishKey = "time_to_fish"
let kPrice24hKey = "price_24h"
let kPriceDayOnlyKey = "price_day_only"
let kPriceNotesKey = "price_notes"
let kBoatUsageKey = "boat_usage"

let kAddressKey = "address"
let kNotesKey = "notes"
let kConveniencesKey = "conveniences"
let kPlaceContactsKey = "place_contacts"

let kRatingsAvgKey = "rating_avg"
let kRatingsVotesKey = "rating_votes"

let kUpdatedAtKey = "updated_at"

// let kPostContent = "post_content"
let kPostContent = "description"
let kPhotosKey = "photos"
let kFishKey = "place_fishes"

let kUrlKey = "url"
let kFeaturedImageKey = "featured_image"

class PlaceContact: NSObject, NSCoding {
    static let kIdKey = "id"
    static let kNameKey = "name"
    static let kPhoneKey = "phone"

    var id: String
    var name: String
    var phone: String

    init?(dict: Dictionary<String, Any>)
    {
        id = dict[PlaceContact.kIdKey] as? String ?? ""
        name = dict[PlaceContact.kNameKey] as? String ?? ""
        phone = dict[PlaceContact.kPhoneKey] as? String ?? ""
    }

    required init(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey: PlaceContact.kIdKey) as? String ?? ""
        name = decoder.decodeObject(forKey: PlaceContact.kNameKey) as? String ?? ""
        phone = decoder.decodeObject(forKey: PlaceContact.kPhoneKey) as? String ?? ""
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PlaceContact.kIdKey)
        aCoder.encode(name, forKey: PlaceContact.kNameKey)
        aCoder.encode(phone, forKey: PlaceContact.kPhoneKey)
    }
}

class PlaceDetails: NSObject, NSCoding {
    var markerID: Int
    var lat: Float
    var lon: Float
    var name: String?

    var area: Float?
    var maxDepth: String?
    var averageDepth: String?

    var permit: String?
    var timeToFish: String?
    var price24: String?
    var dayhourPrice: String?
    var priceNotes: String?
    var boatUsage: String?

    var address: String?
    var notes: String?
    var conveniences: String?
    var placeContacts: [PlaceContact]?

    var ratingAvg: String?
    var ratingVotes: String?

    var modifiedDate: String?

    var photoUrls: Array<String>?
    var fish: Array<PlaceFish>?

    var content: String?
    var url: String?
    private let featuredImageUrl: String?
    var mainImgUrlStr: String? {
        get {
            return featuredImageUrl ?? photoUrls?.first
        }
    }

    var areaStr: String? {
        if let val = area , val != 0.0 {
            return NSLocalizedString("\(val / 100) Га", comment: "area")
        }
        return nil
    }

    var permitStr: String {
        let val = permit ?? ""
        switch val {
        case "paid":
            return NSLocalizedString("платно", comment: "paid")
        case "free":
            return NSLocalizedString("безкоштовно", comment: "free")
        case "prohibited":
            return NSLocalizedString("рибалити заборонено", comment: "fishing prohibited")
        case "unknown":
            return ""
        default:
            return ""
        }
    }

    var maxDepthReadable: String? {
        if let maxDepth = self.maxDepth {
            return "\(maxDepth) м"
        }
        return maxDepth
    }

    var averageDepthReadable: String? {
        if let averageDepth = self.averageDepth {
            return "\(averageDepth) м"
        }
        return averageDepth
    }

    var boatUsageReadable: String? {
        if let val = boatUsage {
            if NSString(string: val).boolValue {
                return NSLocalizedString("дозволено", comment: "allowed")
            } else {
                return NSLocalizedString("заборонено", comment: "not allowed")
            }
        }
        return nil
    }

    var modifyDateLocalized: String? {
        guard let origDateStr = modifiedDate else { return nil }

        let kFormat = "yyyy-MM-dd"
        let dayStr = origDateStr.substring(with: origDateStr.startIndex ..< origDateStr.characters.index(origDateStr.startIndex, offsetBy: 10))

        let formatter = DateFormatter()
        formatter.dateFormat = kFormat

        if let date = formatter.date(from: dayStr) {
            formatter.dateStyle = DateFormatter.Style.long
            return formatter.string(from: date)
        }
        return origDateStr
    }

    var timeToFishStr: String? {
        if let val = timeToFish {
            if val == "day_only" {
                return "лише вдень"
            } else if val == "full_day" {
                return "цілодобово"
            } else if val == "unknown" {
                return nil
            }
        }
        return timeToFish
    }

    required init(coder decoder: NSCoder) {
        markerID = decoder.decodeInteger(forKey: kMarkerIDKey)
        lat = decoder.decodeFloat(forKey: kLatKey)
        lon = decoder.decodeFloat(forKey: kLonKey)
        name = decoder.decodeObject(forKey: kNameKey) as? String

        area = decoder.decodeFloat(forKey: kAreaKey) as? Float
        maxDepth = decoder.decodeObject(forKey: kDepthMaxKey) as? String
        averageDepth = decoder.decodeObject(forKey: kDepthAvgKey) as? String

        permit = decoder.decodeObject(forKey: kPermitKey) as? String
        timeToFish = decoder.decodeObject(forKey: kTimeToFishKey) as? String
        price24 = decoder.decodeObject(forKey: kPrice24hKey) as? String
        dayhourPrice = decoder.decodeObject(forKey: kPriceDayOnlyKey) as? String
        priceNotes = decoder.decodeObject(forKey: kPriceNotesKey) as? String
        boatUsage = decoder.decodeObject(forKey: kBoatUsageKey) as? String

        address = decoder.decodeObject(forKey: kAddressKey) as? String
        notes = decoder.decodeObject(forKey: kNotesKey) as? String
        conveniences = decoder.decodeObject(forKey: kConveniencesKey) as? String
        placeContacts = decoder.decodeObject(forKey: kPlaceContactsKey) as? Array<PlaceContact>

        modifiedDate = decoder.decodeObject(forKey: kUpdatedAtKey) as? String

        content = decoder.decodeObject(forKey: kPostContent) as? String
        photoUrls = decoder.decodeObject(forKey: kPhotosKey) as? Array
        fish = decoder.decodeObject(forKey: kFishKey) as? Array<PlaceFish>

        url = decoder.decodeObject(forKey: kUrlKey) as? String
        featuredImageUrl = decoder.decodeObject(forKey: kFeaturedImageKey) as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(markerID, forKey: kMarkerIDKey)
        aCoder.encode(lat, forKey: kLatKey)
        aCoder.encode(lon, forKey: kLonKey)
        aCoder.encode(name, forKey: kNameKey)

        aCoder.encode(area, forKey: kAreaKey)
        aCoder.encode(maxDepth, forKey: kDepthMaxKey)
        aCoder.encode(averageDepth, forKey: kDepthAvgKey)

        aCoder.encode(permit, forKey: kPermitKey)
        aCoder.encode(timeToFish, forKey: kTimeToFishKey)
        aCoder.encode(price24, forKey: kPrice24hKey)
        aCoder.encode(dayhourPrice, forKey: kPriceDayOnlyKey)
        aCoder.encode(priceNotes, forKey: kPriceNotesKey)
        aCoder.encode(boatUsage, forKey: kBoatUsageKey)

        aCoder.encode(address, forKey: kAddressKey)
        aCoder.encode(notes, forKey: kNotesKey)
        aCoder.encode(conveniences, forKey: kConveniencesKey)
        aCoder.encode(placeContacts, forKey: kPlaceContactsKey)

        aCoder.encode(ratingAvg, forKey: kRatingsAvgKey)
        aCoder.encode(ratingVotes, forKey: kRatingsVotesKey)

        aCoder.encode(modifiedDate, forKey: kUpdatedAtKey)

        aCoder.encode(content, forKey: kPostContent)
        aCoder.encode(photoUrls, forKey: kPhotosKey)
        aCoder.encode(fish, forKey: kFishKey)

        aCoder.encode(url, forKey: kUrlKey)
        aCoder.encode(featuredImageUrl, forKey: kFeaturedImageKey)
    }

    init(dict: NSDictionary)
    {
        markerID = dict[kMarkerIDKey] as! Int
        lat = Float(dict[kLatKey] as! String)!
        lon = Float(dict[kLonKey] as! String)!
        name = dict[kNameKey] as? String

        if let areaStr = dict[kAreaKey] as? String {
            area = Float(areaStr)
        }
        
        maxDepth = dict[kDepthMaxKey] as? String
        averageDepth = dict[kDepthAvgKey] as? String

        permit = dict[kPermitKey] as? String
        timeToFish = dict[kTimeToFishKey] as? String
        price24 = dict[kPrice24hKey] as? String
        dayhourPrice = dict[kPriceDayOnlyKey] as? String
        priceNotes = dict[kPriceNotesKey] as? String
        boatUsage = dict[kBoatUsageKey] as? String

        address = dict[kAddressKey] as? String
        notes = dict[kNotesKey] as? String
        conveniences = dict[kConveniencesKey] as? String
        if let contactsDictArr = dict[kPlaceContactsKey] as? Array<Dictionary<String, Any>> {
            var arr: [PlaceContact] = []
            for contactsDict in contactsDictArr {
                if let contact = PlaceContact(dict: contactsDict) {
                    arr.append(contact)
                }
            }
            placeContacts = arr
        }

        ratingAvg = dict[kRatingsAvgKey] as? String
        ratingVotes = dict[kRatingsVotesKey] as? String

        modifiedDate = dict[kUpdatedAtKey] as? String

        content = dict[kPostContent] as? String
        photoUrls = dict[kPhotosKey] as? Array<String>
        if let fishDictArr = dict[kFishKey] as? Array<Dictionary<String, Any>> {
            fish = Array<PlaceFish>()
            for fishDict in fishDictArr {
                if let f = PlaceFish(dict: fishDict) {
                    fish?.append(f)
                }
            }
        }
        url = dict[kUrlKey] as? String
        featuredImageUrl = dict[kFeaturedImageKey] as? String
    }
}
