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

let kFishIDKey = "id"
let kFishNameKey = "name"
let kLatinNameKey = "name_latin"
let kFolkNameKey = "name_folk"
let kEngNameKey = "name_eng"

let kSlugKey = "slug"
let kPredatorKey = "predator"
let kRedBookKey = "redbook"
let kDescriptionKey = "description"
let kIconUrlKey = "icon_url"

class Fish: NSObject, NSCoding {

    var name: String?
    var latinName: String?
    var folkName: String?
    var engName: String?
    var image: UIImage?

    var id: Int?
    var iconUrl: String?
    var predatorKey: NSNumber?
    var redBook: Bool?
    var fishDescription: String?

    init(dict: Dictionary<String, Any>)
    {
        id = dict[kFishIDKey] as? Int
        name = dict[kFishNameKey] as? String
        iconUrl = dict[kIconUrlKey] as? String
        if let id = id {
            image = UIImage(named: "\(id)")
        }
    }

    required init(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey: kFishIDKey) as? Int
        name = decoder.decodeObject(forKey: kFishNameKey) as? String
        iconUrl = decoder.decodeObject(forKey: kIconUrlKey) as? String
        if let id = id {
            image = UIImage(named: "\(id)")
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: kFishIDKey)
        aCoder.encode(name, forKey: kFishNameKey)
        aCoder.encode(iconUrl, forKey: kIconUrlKey)
    }
}
