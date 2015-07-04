//
//  JSONParser.swift
//  RivneFish
//
//  Created by akyryl on 04/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import Foundation

class DataParser {

    func parseCountries(jsonData: NSData) -> NSArray {
        var err: NSError
        var countriesData: NSArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSArray

        var countries = NSMutableArray(capacity: countriesData.count)
        for countryDict in countriesData as! [NSDictionary] {
            var countryName = countryDict["name"] as! NSString
            countries.addObject(countryName)
        }
        return countries;
    }
}
