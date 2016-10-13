//
//  NetworkDataSource.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 28/02/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class NetworkDataSource {

    static var sharedInstace = NetworkDataSource()

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

    func allAvailableMarkers(completionHandler: (markers: NSArray) -> Void) {
        let urlStr = "http://api.rivnefish.com/markers/"
        HTTPClient.sharedInstance.request(urlStr, responseCallback:
            // HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers/?permit=paid", responseCallback:
            // HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers/?distance_lower=15", responseCallback:
            {(data: NSData!, response: NSURLResponse!, error: NSError!) in

                if self.errorInResponse(response) {
                    completionHandler(markers: NSArray())
                    return;
                }

                if let json = data {
                    let dataParser = DataParser()
                    let markers = dataParser.parseMarkers(json)
                    completionHandler(markers: markers)
                }
                else {
                    print(NSString(data: data, encoding: NSUTF8StringEncoding))
                }
        })
    }

    func lastChanges(completionHandler: (lastChanges: NSNumber) -> Void) {
        HTTPClient.sharedInstance.request("http://api.rivnefish.com/lastchanges/", responseCallback: {(data: NSData!, response: NSURLResponse!, error: NSError!) in

            if self.errorInResponse(response) {
                completionHandler(lastChanges: NSNumber())
                return;
            }

            if let json = data {
                let dataParser = DataParser()
                let num = dataParser.parseLastChanges(json)
                completionHandler(lastChanges: num)
            }
            else {
                print(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
        })
    }

    func fishForMarkerID(id: String, fishReceived: (fish: NSArray) -> Void) {
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

    func getDataFromUrl(urL: NSURL, completion: ((data: NSData?, url: String) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            if let string = urL.absoluteString {
                completion(data: data, url: string)
            }
        }.resume()
    }

    func errorInResponse(response: NSURLResponse?) -> Bool {
        var result = true
        if let response = response {
            let statusCodeData: AnyObject? = response.valueForKey("statusCode")
            if let statusCode: NSInteger = statusCodeData as? NSInteger {
                let code = statusCode
                result = (code == 0)
            }
        }
        return result
    }
}
