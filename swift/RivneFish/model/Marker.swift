//
//  Marker.swift
//  RivneFish
//
//  Created by akyryl on 06/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import Foundation

let kMarkerIDKey = "marker_id"
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

class MarkerModel: NSObject, NSCoding {

    var markerID: NSNumber
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

    var contactReadable: String? {
        if let tel = contact {
            var s = tel
            if s.characters.first != "+" {
                s.insert("+", atIndex: s.characters.startIndex)
            }
            if s.characters.count >= 13 {
                return String(format: "%@ (%@) %@ %@ %@", s.substringToIndex(s.startIndex.advancedBy(4)),
                              s.substringWithRange(s.startIndex.advancedBy(4) ... s.startIndex.advancedBy(5)),
                              s.substringWithRange(s.startIndex.advancedBy(6) ... s.startIndex.advancedBy(8)),
                              s.substringWithRange(s.startIndex.advancedBy(9) ... s.startIndex.advancedBy(10)),
                              s.substringWithRange(s.startIndex.advancedBy(11) ... s.startIndex.advancedBy(12))
                )
            }
        }
        return contact
    }

    var areaStr: String? {
        if let val = area where val != 0.0 {
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
        let dayStr = origDateStr.substringWithRange(origDateStr.startIndex ..< origDateStr.startIndex.advancedBy(10))

        let formatter = NSDateFormatter()
        formatter.dateFormat = kFormat

        if let date = formatter.dateFromString(dayStr) {
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            return formatter.stringFromDate(date)
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
        markerID = (decoder.decodeObjectForKey(kMarkerIDKey) as? NSNumber)!
        lat = (decoder.decodeObjectForKey(kLatKey) as? Float)!
        lon = (decoder.decodeObjectForKey(kLonKey) as? Float)!

        name = decoder.decodeObjectForKey(kNameKey) as? String
        address = decoder.decodeObjectForKey(kAddressKey) as? String
        area = decoder.decodeObjectForKey(kAreaKey) as? Float
        content = decoder.decodeObjectForKey(kContentKey) as? String
        conveniences = decoder.decodeObjectForKey(kConveniencesKey) as? String
        contact = decoder.decodeObjectForKey(kContactKey) as? String
        contactName = decoder.decodeObjectForKey(kContactNameKey) as? String
        maxDepth = decoder.decodeObjectForKey(kMaxDepthKey) as? String
        averageDepth = decoder.decodeObjectForKey(kAverageDepthKey) as? String
        permit = decoder.decodeObjectForKey(kPermitKey) as? String
        price24 = decoder.decodeObjectForKey(kPrice24hKey) as? String
        dayhourPrice = decoder.decodeObjectForKey(kDayhourPriceKey) as? String
        boatUsage = decoder.decodeObjectForKey(kBoatUsageKey) as? String
        timeToFish = decoder.decodeObjectForKey(kTimeToFishKey) as? String
        paidFish = decoder.decodeObjectForKey(kPaidFishKey) as? String
        note = decoder.decodeObjectForKey(kNoteKey) as? String
        note2 = decoder.decodeObjectForKey(kNote2Key) as? String
        createDate = decoder.decodeObjectForKey(kCreateDateKey) as? String
        modifyDate = decoder.decodeObjectForKey(kModifyDateKey) as? String
        region = decoder.decodeObjectForKey(kRegionKey) as? String
        district = decoder.decodeObjectForKey(kDistrictKey) as? String
        country = decoder.decodeObjectForKey(kCountryKey) as? String
        photoUrls = decoder.decodeObjectForKey(kPhotosKey) as? Array
        url = decoder.decodeObjectForKey(kUrlKey) as? String
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(markerID, forKey: kMarkerIDKey)
        aCoder.encodeObject(lat, forKey: kLatKey)
        aCoder.encodeObject(lon, forKey: kLonKey)

        aCoder.encodeObject(name, forKey: kNameKey)
        aCoder.encodeObject(address, forKey: kAddressKey)
        aCoder.encodeObject(area, forKey: kAreaKey)
        aCoder.encodeObject(content, forKey: kContentKey)
        aCoder.encodeObject(conveniences, forKey: kConveniencesKey)
        aCoder.encodeObject(contact, forKey: kContactKey)
        aCoder.encodeObject(contactName, forKey: kContactNameKey)
        aCoder.encodeObject(maxDepth, forKey: kMaxDepthKey)
        aCoder.encodeObject(averageDepth, forKey: kAverageDepthKey)
        aCoder.encodeObject(permit, forKey: kPermitKey)
        aCoder.encodeObject(price24, forKey: kPrice24hKey)
        aCoder.encodeObject(dayhourPrice, forKey: kDayhourPriceKey)
        aCoder.encodeObject(boatUsage, forKey: kBoatUsageKey)
        aCoder.encodeObject(timeToFish, forKey: kTimeToFishKey)
        aCoder.encodeObject(paidFish, forKey: kPaidFishKey)
        aCoder.encodeObject(note, forKey: kNoteKey)
        aCoder.encodeObject(note2, forKey: kNote2Key)
        aCoder.encodeObject(createDate, forKey: kCreateDateKey)
        aCoder.encodeObject(modifyDate, forKey: kModifyDateKey)
        aCoder.encodeObject(region, forKey: kRegionKey)
        aCoder.encodeObject(district, forKey: kDistrictKey)
        aCoder.encodeObject(country, forKey: kCountryKey)
        aCoder.encodeObject(photoUrls, forKey: kPhotosKey)
        aCoder.encodeObject(url, forKey: kUrlKey)
    }

    init(dict: NSDictionary)
    {
        markerID = dict[kMarkerIDKey] as! NSNumber
        lat = dict[kLatKey] as! Float
        lon = dict[kLonKey] as! Float

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
    }
}
