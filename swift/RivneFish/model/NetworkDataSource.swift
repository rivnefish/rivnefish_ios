//
//  NetworkDataSource.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 28/02/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class NetworkDataSource {

    static var sharedInstace = NetworkDataSource()

    func coutries(_ countriesReceived: @escaping (_ countries: NSArray) -> Void) {
        HTTPClient.sharedInstance.request("http://api.rivnefish.com/countries/", responseCallback: {(data: Data?, response: URLResponse?, error: NSError?) in

            if self.errorInResponse(response) {
                countriesReceived(NSArray())
                return;
            }

            if let json = data {
                let dataParser = DataParser()
                let countries = dataParser.parseCountries(json)
                countriesReceived(countries)
            }
            else {
                if let data = data {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                }
            }
        } as (Data?, URLResponse?, NSError?) -> Void)
    }

    func allAvailableMarkers(_ completionHandler: @escaping (_ markers: NSArray) -> Void) {
        let urlStr = "http://api.rivnefish.com/markers/"
        HTTPClient.sharedInstance.request(urlStr as NSString, responseCallback:
            // HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers/?permit=paid", responseCallback:
            // HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers/?distance_lower=15", responseCallback:
            {(data: Data?, response: URLResponse?, error: NSError?) in

                if self.errorInResponse(response) {
                    completionHandler(NSArray())
                    return;
                }

                if let json = data {
                    let dataParser = DataParser()
                    let markers = dataParser.parseMarkers(json)
                    completionHandler(markers)
                }
                else {
                    if let data = data {
                        print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                    }
                }
        } as (Data?, URLResponse?, NSError?) -> Void)
    }

    func lastChanges(_ completionHandler: @escaping (_ lastChanges: Int) -> Void) {
        HTTPClient.sharedInstance.request("http://api.rivnefish.com/lastchanges/", responseCallback: {(data: Data?, response: URLResponse?, error: NSError?) in

            if self.errorInResponse(response) {
                completionHandler(0)
                return;
            }

            if let json = data {
                let dataParser = DataParser()
                let num = dataParser.parseLastChanges(json)
                completionHandler(num)
            }
            else {
                if let data = data {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                }
            }
        } as (Data?, URLResponse?, NSError?) -> Void)
    }

    func fishForMarkerID(_ id: String, fishReceived: @escaping (_ fish: NSArray) -> Void) {
        HTTPClient.sharedInstance.request("http://api.rivnefish.com/markers-fishes/?marker=\(id)" as NSString, responseCallback: {(data: Data?, response: URLResponse?, error: NSError?) in

            if self.errorInResponse(response) {
                fishReceived(NSArray())
                return;
            }

            if let json = data {
                let dataParser = DataParser()
                let fish = dataParser.parseFish(json)
                fishReceived(fish)
            }
            else {
                if let data = data {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                }
            }
        } as (Data?, URLResponse?, NSError?) -> Void)
    }

    func getDataFromUrl(_ urL: URL, completion: @escaping ((_ data: Data?, _ url: String?) -> Void)) {
        URLSession.shared.dataTask(with: urL, completionHandler: { (data, response, error) in
            if let data = data {
                completion(data, urL.absoluteString)
            }
        }) .resume()
    }

    func errorInResponse(_ response: URLResponse?) -> Bool {
        var result = true
        if let response = response {
            let statusCodeData: AnyObject? = response.value(forKey: "statusCode") as AnyObject?
            if let statusCode: NSInteger = statusCodeData as? NSInteger {
                let code = statusCode
                result = (code == 0)
            }
        }
        return result
    }
}
