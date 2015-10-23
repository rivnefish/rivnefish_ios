//
//  DataSource.swift
//  RivneFish
//
//  Created by akyryl on 20/06/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit

class DataSource: NSObject {

    func coutries(countriesReceived: (countries: NSArray) -> Void) {
        HTTPClient.sharedInstance.request("http://api.rivnefish.com/countries/", responseCallback: {(data: NSData!, response: NSURLResponse!, error: NSError!) in

            if self.errorInResponse(response) {
                countriesReceived(countries: NSArray())
                return;
            }

            if let json = data {
                let dataParser = DataParser()
                let countries = dataParser.parseCountries(json)
                countriesReceived(countries: countries)
            }
            else {
                print(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
        })
    }

    func allAvailableMarkers(markersReceived: (markers: NSArray) -> Void) {
            HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers/", responseCallback:
            // HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers/?permit=paid", responseCallback:
            // HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers/?distance_lower=15", responseCallback:
                {(data: NSData!, response: NSURLResponse!, error: NSError!) in

            if self.errorInResponse(response) {
                markersReceived(markers: NSArray())
                return;
            }

            if let json = data {
                let dataParser = DataParser()
                let markers = dataParser.parseMarkers(json)
                markersReceived(markers: markers)
            }
            else {
                print(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
        })
    }
    
    func fishForMarkerID(id: Int, fishReceived: (fish: NSArray) -> Void) {
        HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers-fishes/?marker=\(id)", responseCallback: {(data: NSData!, response: NSURLResponse!, error: NSError!) in
            
            if self.errorInResponse(response) {
                fishReceived(fish: NSArray())
                return;
            }
            
            if let json = data {
                let dataParser = DataParser()
                let fish = dataParser.parseFish(json)
                fishReceived(fish: fish)
            }
            else {
                print(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
        })
    }

    func errorInResponse(response: NSURLResponse?) -> Bool {
        var result = true
        if let response = response {
            let statusCodeData: AnyObject? = response.valueForKey("statusCode")
            if let statusCode: NSInteger = statusCodeData as? NSInteger {
                let code = Int(statusCode.value)
                result = (code == 0)
            }
        }
        return result
    }
}
