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

class Marker {

    var markerID: NSNumber
    var lat: Float
    var lon: Float

    var name: String?
    var address: String?
    var area: Int?
    var content: String?
    var conveniences: String?
    var contact: String?
    var contactName: String?
    var maxDepth: Float?
    var averageDepth: Float?
    var permit: String?
    var price24: String?
    var dayhourPrice: String?
    var boatUsage: Bool?
    var timeToFish: String?
    var paidFish: String?
    var note: String?
    var note2: String?
    var createDate: NSDate?
    var modifyDate: NSDate?
    var region: String?
    var district: String?
    var country: String?
    var photoUrls: Array<String>?
    var url: String?

    init(dict: NSDictionary)
    {
        markerID = dict[kMarkerIDKey] as! NSNumber
        lat = dict[kLatKey] as! Float
        lon = dict[kLonKey] as! Float

        name = dict[kNameKey] as? String
        address = dict[kAddressKey] as? String
        area = dict[kAreaKey] as? Int
        content = dict[kContentKey] as? String
        conveniences = dict[kConveniencesKey] as? String
        contact = dict[kContactKey] as? String
        contactName = dict[kContactNameKey] as? String
        maxDepth = dict[kMaxDepthKey] as? Float
        averageDepth = dict[kAverageDepthKey] as? Float
        permit = dict[kPermitKey] as? String
        price24 = dict[kPrice24hKey] as? String
        dayhourPrice = dict[kDayhourPriceKey] as? String
        boatUsage = dict[kBoatUsageKey] as? Bool
        timeToFish = dict[kTimeToFishKey] as? String
        paidFish = dict[kPaidFishKey] as? String
        note = dict[kNoteKey] as? String
        note2 = dict[kNote2Key] as? String
        createDate = dict[kCreateDateKey] as? NSDate
        modifyDate = dict[kModifyDateKey] as? NSDate
        region = dict[kRegionKey] as? String
        district = dict[kDistrictKey] as? String
        country = dict[kCountryKey] as? String
        photoUrls = dict[kPhotosKey] as? Array<String>
        url = dict[kUrlKey] as? String
    }
}
