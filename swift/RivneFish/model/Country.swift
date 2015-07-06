//
//  Country.swift
//  RivneFish
//
//  Created by akyryl on 06/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import Foundation

let kCountryNameKey = "name"

class Country {

    var countryName: NSString

    init(dict: NSDictionary)
    {
        countryName = dict[kCountryNameKey] as! NSString
    }
}
