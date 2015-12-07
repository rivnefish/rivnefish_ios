//
//  Fish.swift
//  RivneFish
//
//  Created by Anatoliy Kyryliuk on 10/2/15.
//  Copyright © 2015 rivnefish. All rights reserved.
//

import Foundation
import UIKit

let kMarkerFishKey = "marker_fish"

let kFishIDKey = "fish_id"
let kPictureKey = "picture"
let kFishNameKey = "name"
let kLatinNameKey = "latin_name"
let kFolkNameKey = "folk_name"
let kIconWidthKey = "icon_width"
let kIconUrlKey = "icon_url"
let kPredatorKey = "predator"
let kEngNameKey = "eng_name"
let kIconHeightKey = "icon_height"
let kRedBookKey = "redbook"
let kArticleUrlKey = "article_url"
let kUkrNameKey = "ukr_name"
let kDescriptionKey = "description"

let kWeightAvgKey = "weight_avg"
let kWeightMaxKey = "weight_max"
let kAmountKey = "amount"
let kNotesKey = "notes"

class Fish {

    var name: String?
    var latinName: String?
    var folkName: String?
    var engName: String?
    var ukrName: String?

    var fishID: NSNumber?
    var picture: String?
    var iconWidth: NSNumber?
    var iconUrl: String?
    var predatorKey: NSNumber?
    var iconHeight: NSNumber?
    var redBook: Bool?
    var articleUrl: String?
    var description: String?
    var weight: Double?
    var maxWeight: Double?
    var amount: Int?
    var notes: String?
    var image: UIImage?
    
    init(dict: NSDictionary)
    {
        let markerFishDict: NSDictionary? = dict[kMarkerFishKey] as? NSDictionary
        if let fishDict = markerFishDict {
            name = fishDict[kFishNameKey] as? String
            ukrName = fishDict[kUkrNameKey] as? String
            iconUrl = fishDict[kIconUrlKey] as? String
            if let num = fishDict[kFishIDKey] as? NSNumber {
                fishID = num
                image = UIImage(named: "\(num)")
            }
            // TODO:
        }
        amount = dict[kAmountKey] as? Int
    }
}
