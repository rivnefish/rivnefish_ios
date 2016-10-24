//
//  JSONParser.swift
//  RivneFish
//
//  Created by akyryl on 04/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import Foundation

class DataParser {
    func parseMarkers(jsonData: Data) -> Array<Place> {
        //print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))

        if let _ = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? NSArray {
            let markersData: NSArray = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSArray ?? NSArray()

            var places = Array<Place>()
            places.reserveCapacity(markersData.count)

            for markerDict in markersData as! [NSDictionary] {

                let marker = Place(dict: markerDict)
                places.append(marker)
            }
            return places
        } else {
            return Array<Place>()
        }
    }

    func parsePlaceDetails(jsonData: Data) -> PlaceDetails? {
        if let placeDetailsDict = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary {
            return PlaceDetails(dict: placeDetailsDict)
        }
        return nil
    }

    func parseFish(_ jsonData: Data) -> Array<Fish>? {
        let fishData = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
        if let dataArr = fishData as? Array<Dictionary<String, Any>> {
            var fishArr = Array<Fish>()
            for fishDict in dataArr {
                let fish = Fish(dict: fishDict)
                fishArr.append(fish)
            }
            return fishArr
        } else {
            return nil
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
