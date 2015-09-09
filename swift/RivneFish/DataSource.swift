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
                var dataParser = DataParser()
                var countries = dataParser.parseCountries(data)
                countriesReceived(countries: countries)
            }
            else {
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
        })
    }

    func allAvailableMarkers(markersReceived: (markers: NSArray) -> Void) {
//        HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers/?permit=paid", responseCallback: 
            HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers/?distance_lower=15", responseCallback: {(data: NSData!, response: NSURLResponse!, error: NSError!) in

            if self.errorInResponse(response) {
                markersReceived(markers: NSArray())
                return;
            }

            if let json = data {
                var dataParser = DataParser()
                var markers = dataParser.parseMarkers(data)
                markersReceived(markers: markers)
            }
            else {
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
        })
    }

    func errorInResponse(response: NSURLResponse) -> Bool {
        var result = true
        let statusCodeData: AnyObject? = response.valueForKey("statusCode")
        if let statusCode: NSInteger = statusCodeData as? NSInteger {
            let code = Int64(statusCode.value)
            result = (code == 0)
        }
        return result
    }

    /*func coutries2(countriesReceived: (countries: NSArray) -> Void) {

        var authValue: String = "Token " + self.token()

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration();
        configuration.HTTPAdditionalHeaders = ["Authorization": authValue];

        var url = NSURL(string: "http://api.rivnefish.com/countries/")
        var session = NSURLSession(configuration:configuration)
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) in

            if let json = data {
                var dataParser = DataParser()
                var countries = dataParser.parseCountries(data)
                countriesReceived(countries: countries)
            }
            else {
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
       }

        task.resume()
    }*/
}
