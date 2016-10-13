//
//  JSONParser.swift
//  RivneFish
//
//  Created by akyryl on 04/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import Foundation

class DataParser {

    func parseCountries(_ jsonData: Data) -> NSArray {
        let countriesData: NSArray = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSArray ?? NSArray()

        let countries = NSMutableArray(capacity: countriesData.count)
        for countryDict in countriesData as! [NSDictionary] {
            let country = Country(dict: countryDict)
            countries.add(country)
        }
        return countries;
    }

    func parseMarkers(_ jsonData: Data) -> NSArray {
        //print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))

        if let _ = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? NSArray {
            let markersData: NSArray = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSArray ?? NSArray()

            let markers = NSMutableArray(capacity: markersData.count)
            for markerDict in markersData as! [NSDictionary] {

                let marker = MarkerModel(dict: markerDict)
                markers.add(marker)
            }
            return markers
        } else {
            return NSArray()
        }
    }
    
    func parseFish(_ jsonData: Data) -> NSArray {
        //print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
        
        if let _ = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? NSArray {
            let fishData: NSArray = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSArray ?? NSArray()
            
            let fishArr = NSMutableArray(capacity: fishData.count)
            for fishDict in fishData as! [NSDictionary] {
                
                let fish = Fish(dict: fishDict)
                fishArr.add(fish)
            }
            return fishArr
        } else {
            return NSArray()
        }
    }

    func parseLastChanges(_ jsonData: Data) -> Int {
        let dateDict = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
        var number = 0
        if let dict = dateDict, let num = ModifiedDate(dict: dict).number {
            number = num
        }
        return number
    }
}
