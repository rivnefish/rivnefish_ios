//
//  DataSource.swift
//  RivneFish
//
//  Created by akyryl on 20/06/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit

//curl -X GET http://api.rivnefish.com/ -H 'Authorization: Token 9a19e9e3082e5ac1b7dd47572bdc1153fd735c68'

class DataSource: NSObject {

    /*func token() -> String
    {
        // TODO: read from keychain
        return "9a19e9e3082e5ac1b7dd47572bdc1153fd735c68"
    }*/

    func coutries(countriesReceived: (countries: NSArray) -> Void) {
        var networkManager = HTTPClient.sharedInstance;
        networkManager.request("http://api.rivnefish.com/countries/", responseCallback: {(data: NSData!, response: NSURLResponse!, error: NSError!) in

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
