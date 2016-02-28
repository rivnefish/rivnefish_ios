//
//  NetworkDataSource.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 28/02/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class NetworkDataSource {

    static var sharedInstace = NetworkDataSource()

    /*func allAvailableMarkers(completionHandler: (jsonData: NSData) -> Void) {
        let urlStr = "http://api.rivnefish.com/markers/"
        HTTPClient.sharedInstance.request(urlStr, responseCallback:
            // HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers/?permit=paid", responseCallback:
            // HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers/?distance_lower=15", responseCallback:
            {(data: NSData!, response: NSURLResponse!, error: NSError!) in

                if self.errorInResponse(response) {
                    completionHandler(jsonData: data)
                    return;
                } else {
                    completionHandler(jsonData: data)
                }
        })
    }*/

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

    func markerModifyDate(completionHandler: (modifyDate: NSDate) -> Void) {
        HTTPClient.sharedInstance.request("http://api.rivnefish.com/lastchanges/", responseCallback: {(data: NSData!, response: NSURLResponse!, error: NSError!) in

            if self.errorInResponse(response) {
                completionHandler(modifyDate: NSDate())
                return;
            }

            if let json = data {
                let dataParser = DataParser()
                //let date = dataParser.parseDate(json)
                //completionHandler(modifyDate: date)
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
