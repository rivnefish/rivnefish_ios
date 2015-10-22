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
        let countriesData: NSArray = (try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)) as! NSArray

        let countries = NSMutableArray(capacity: countriesData.count)
        for countryDict in countriesData as! [NSDictionary] {
            let country = Country(dict: countryDict)
            countries.addObject(country)
        }
        return countries;
    }

    func parseMarkers(jsonData: NSData) -> NSArray {
        //print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))

        if let json = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])) as? NSArray {
            let markersData: NSArray = (try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)) as! NSArray

            let markers = NSMutableArray(capacity: markersData.count)
            for markerDict in markersData as! [NSDictionary] {

                let marker = Marker(dict: markerDict)
                markers.addObject(marker)
            }
            return markers
        } else {
            return NSArray()
        }
    }
    
    func parseFish(jsonData: NSData) -> NSArray {
        //print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
        
        if let json = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])) as? NSArray {
            let fishData: NSArray = (try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)) as! NSArray
            
            let fishArr = NSMutableArray(capacity: fishData.count)
            for fishDict in fishData as! [NSDictionary] {
                
                let fish = Fish(dict: fishDict)
                fishArr.addObject(fish)
            }
            return fishArr
        } else {
            return NSArray()
        }
    }
}
