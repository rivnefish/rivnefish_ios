//
//  Marker.swift
//  RivneFish
//
//  Created by akyryl on 06/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import Foundation

let kMarkerIDKey = "id"
let kNameKey = "name"
let kAddressKey = "address"
let kLatKey = "lat"
let kLonKey = "lng"
let kAreaKey = "area"
let kContentKey = "content"
let kConveniencesKey = "conveniences"
let kContactKey = "contact"
let kContactNameKey = "contact_name"
let kMaxDepthKey = "max_depth"
let kAverageDepthKey = "average_depth"
// let kDistanceToRivneKey = "distance_to_rivne"
let kPermitKey = "permit"
let kPrice24hKey = "price_24h"
let kDayhourPriceKey = "dayhour_price"
let kBoatUsageKey = "boat_usage"
let kTimeToFishKey = "time_to_fish"
let kPaidFishKey = "paid_fish"
let kNoteKey = "note"
let kNote2Key = "note2"
// let kphotoUrlKey = "photo_url"
let kApprovalKey = "approval"
let kCreateDateKey = "create_date"
let kModifyDateKey = "modify_date"
// let kAuthorIdKey = "author_id"
// let kPostIdKey = "post_id"
// let kGalleryIdKey = "gallery_id"
let kRegionKey = "region"
let kDistrictKey = "district"
let kCountryKey = "country"
let kPhotosKey = "photos"
let kUrlKey = "url"
let kFishKey = "place_fishes"

class PlaceDetails: NSObject, NSCoding {

    var markerID: Int
    var lat: Float
    var lon: Float

    var name: String?
    var address: String?
    var area: Float?
    var content: String?
    var conveniences: String?
    var contact: String?
    var contactName: String?
    var maxDepth: String?
    var averageDepth: String?
    var permit: String?
    var price24: String?
    var dayhourPrice: String?
    var boatUsage: String?
    var timeToFish: String?
    var paidFish: String?
    var note: String?
    var note2: String?
    var createDate: String?
    var modifyDate: String?
    var region: String?
    var district: String?
    var country: String?
    var photoUrls: Array<String>?
    var url: String?
    var modifiedDate: Date?
    var fish: Array<PlaceFish>?

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
        guard let origDateStr = modifyDate else { return nil }

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
            if val == "daylight" {
                return "лише вдень"
            } else if val == "24h" {
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
        address = decoder.decodeObject(forKey: kAddressKey) as? String
        area = decoder.decodeObject(forKey: kAreaKey) as? Float
        content = decoder.decodeObject(forKey: kContentKey) as? String
        conveniences = decoder.decodeObject(forKey: kConveniencesKey) as? String
        contact = decoder.decodeObject(forKey: kContactKey) as? String
        contactName = decoder.decodeObject(forKey: kContactNameKey) as? String
        maxDepth = decoder.decodeObject(forKey: kMaxDepthKey) as? String
        averageDepth = decoder.decodeObject(forKey: kAverageDepthKey) as? String
        permit = decoder.decodeObject(forKey: kPermitKey) as? String
        price24 = decoder.decodeObject(forKey: kPrice24hKey) as? String
        dayhourPrice = decoder.decodeObject(forKey: kDayhourPriceKey) as? String
        boatUsage = decoder.decodeObject(forKey: kBoatUsageKey) as? String
        timeToFish = decoder.decodeObject(forKey: kTimeToFishKey) as? String
        paidFish = decoder.decodeObject(forKey: kPaidFishKey) as? String
        note = decoder.decodeObject(forKey: kNoteKey) as? String
        note2 = decoder.decodeObject(forKey: kNote2Key) as? String
        createDate = decoder.decodeObject(forKey: kCreateDateKey) as? String
        modifyDate = decoder.decodeObject(forKey: kModifyDateKey) as? String
        region = decoder.decodeObject(forKey: kRegionKey) as? String
        district = decoder.decodeObject(forKey: kDistrictKey) as? String
        country = decoder.decodeObject(forKey: kCountryKey) as? String
        photoUrls = decoder.decodeObject(forKey: kPhotosKey) as? Array
        url = decoder.decodeObject(forKey: kUrlKey) as? String
        fish = decoder.decodeObject(forKey: kFishKey) as? Array<PlaceFish>
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(markerID, forKey: kMarkerIDKey)
        aCoder.encode(lat, forKey: kLatKey)
        aCoder.encode(lon, forKey: kLonKey)

        aCoder.encode(name, forKey: kNameKey)
        aCoder.encode(address, forKey: kAddressKey)
        aCoder.encode(area, forKey: kAreaKey)
        aCoder.encode(content, forKey: kContentKey)
        aCoder.encode(conveniences, forKey: kConveniencesKey)
        aCoder.encode(contact, forKey: kContactKey)
        aCoder.encode(contactName, forKey: kContactNameKey)
        aCoder.encode(maxDepth, forKey: kMaxDepthKey)
        aCoder.encode(averageDepth, forKey: kAverageDepthKey)
        aCoder.encode(permit, forKey: kPermitKey)
        aCoder.encode(price24, forKey: kPrice24hKey)
        aCoder.encode(dayhourPrice, forKey: kDayhourPriceKey)
        aCoder.encode(boatUsage, forKey: kBoatUsageKey)
        aCoder.encode(timeToFish, forKey: kTimeToFishKey)
        aCoder.encode(paidFish, forKey: kPaidFishKey)
        aCoder.encode(note, forKey: kNoteKey)
        aCoder.encode(note2, forKey: kNote2Key)
        aCoder.encode(createDate, forKey: kCreateDateKey)
        aCoder.encode(modifyDate, forKey: kModifyDateKey)
        aCoder.encode(region, forKey: kRegionKey)
        aCoder.encode(district, forKey: kDistrictKey)
        aCoder.encode(country, forKey: kCountryKey)
        aCoder.encode(photoUrls, forKey: kPhotosKey)
        aCoder.encode(url, forKey: kUrlKey)
        aCoder.encode(fish, forKey: kFishKey)
    }

    init(dict: NSDictionary)
    {
        markerID = dict[kMarkerIDKey] as! Int
        lat = Float(dict[kLatKey] as! String)!
        lon = Float(dict[kLonKey] as! String)!

        name = dict[kNameKey] as? String
        address = dict[kAddressKey] as? String
        area = dict[kAreaKey] as? Float
        content = dict[kContentKey] as? String
        conveniences = dict[kConveniencesKey] as? String
        contact = dict[kContactKey] as? String
        contactName = dict[kContactNameKey] as? String
        maxDepth = dict[kMaxDepthKey] as? String
        averageDepth = dict[kAverageDepthKey] as? String
        permit = dict[kPermitKey] as? String
        price24 = dict[kPrice24hKey] as? String
        dayhourPrice = dict[kDayhourPriceKey] as? String
        boatUsage = dict[kBoatUsageKey] as? String
        timeToFish = dict[kTimeToFishKey] as? String
        paidFish = dict[kPaidFishKey] as? String
        note = dict[kNoteKey] as? String
        note2 = dict[kNote2Key] as? String
        createDate = dict[kCreateDateKey] as? String
        modifyDate = dict[kModifyDateKey] as? String
        region = dict[kRegionKey] as? String
        district = dict[kDistrictKey] as? String
        country = dict[kCountryKey] as? String
        photoUrls = dict[kPhotosKey] as? Array<String>
        url = dict[kUrlKey] as? String
        if let fishDictArr = dict[kFishKey] as? Array<Dictionary<String, Any>> {
            fish = Array<PlaceFish>()
            for fishDict in fishDictArr {
                if let f = PlaceFish(dict: fishDict) {
                    fish?.append(f)
                }
            }
        }
    }
}
