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
            var country = Country(dict: countryDict)
            countries.addObject(country)
        }
        return countries;
    }

    func parseMarkers(jsonData: NSData) -> NSArray {
        println(NSString(data: jsonData, encoding: NSUTF8StringEncoding))

        if let json = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? NSArray {
            var markersData: NSArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSArray

            var markers = NSMutableArray(capacity: markersData.count)
            for markerDict in markersData as! [NSDictionary] {

                let marker = Marker(dict: markerDict)
                markers.addObject(marker)
            }
            return markers
        } else {
            return NSArray()
        }
    }
}
