//
//  NetworkDataSource.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 28/02/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class NetworkDataSource {

    static var sharedInstace = NetworkDataSource()

    func places(_ completionHandler: @escaping (_ markers: Array<Place>?) -> Void) {
        let urlStr = Constants.Network.kPlacesUrl
        HTTPClient.sharedInstance.request(urlStr as NSString, responseCallback: {
            (data: Data?, response: URLResponse?, error: NSError?) in

                if self.errorInResponse(response) {
                    completionHandler(nil)
                    return;
                }

                if let json = data {
                    let dataParser = DataParser()
                    let markers = dataParser.parseMarkers(jsonData: json)
                    completionHandler(markers)
                }
                else {
                    if let data = data {
                        print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "")
                    }
                }
        } as (Data?, URLResponse?, NSError?) -> Void)
    }

    func placeDetails(id: Int, completionHandler: @escaping (_ placeDetails: PlaceDetails?) -> Void) {
        let urlStr = Constants.Network.kPlacesUrl + "/\(id)"
        HTTPClient.sharedInstance.request(urlStr as NSString, responseCallback: {
            (data: Data?, response: URLResponse?, error: NSError?) in

            if self.errorInResponse(response) {
                completionHandler(nil)
                return;
            }

            if let json = data {
                let dataParser = DataParser()
                let placeDetails = dataParser.parsePlaceDetails(jsonData: json)
                completionHandler(placeDetails)
            }
            else {
                if let data = data {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "")
                }
            }
        } as (Data?, URLResponse?, NSError?) -> Void)
    }

    func placesLastChanges(_ completionHandler: @escaping (_ lastChanges: String?) -> Void) {
        let urlStr = Constants.Network.kPlacesLastChangesUrl
        lastChanges(urlStr: urlStr, completionHandler: completionHandler)
    }

    func fishLastChanges(_ completionHandler: @escaping (_ lastChanges: String?) -> Void) {
        let urlStr = Constants.Network.kFishLastChangesUrl
        lastChanges(urlStr: urlStr, completionHandler: completionHandler)
    }

    private func lastChanges(urlStr: String, completionHandler: @escaping (_ lastChanges: String?) -> Void) {
        HTTPClient.sharedInstance.request(urlStr as NSString, responseCallback: {(data: Data?, response: URLResponse?, error: NSError?) in

            if self.errorInResponse(response) {
                completionHandler(nil)
                return;
            }

            if let json = data {
                let dataParser = DataParser()
                let num = dataParser.parseLastChanges(json)
                completionHandler(num)
            }
            else {
                if let data = data {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "")
                }
            }
        } as (Data?, URLResponse?, NSError?) -> Void)
    }

    func fishAll(fishReceived: @escaping (_ fish: Array<Fish>?) -> Void) {
        let urlStr = Constants.Network.kFishUrl
        HTTPClient.sharedInstance.request(urlStr as NSString, responseCallback: {(data: Data?, response: URLResponse?, error: NSError?) in

            if self.errorInResponse(response) {
                fishReceived(nil)
                return;
            }

            if let json = data {
                let dataParser = DataParser()
                let fish = dataParser.parseFish(json)
                fishReceived(fish)
            }
            else {
                if let data = data {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "")
                }
            }
        } as (Data?, URLResponse?, NSError?) -> Void)
    }

    func fishForMarkerID(_ id: Int, fishReceived: @escaping (_ fish: Array<Fish>?) -> Void) {
        let urlStr = Constants.Network.kFishUrl + "/\(id)"
        HTTPClient.sharedInstance.request(urlStr as NSString, responseCallback: {(data: Data?, response: URLResponse?, error: NSError?) in

            if self.errorInResponse(response) {
                fishReceived(nil)
                return;
            }

            if let json = data {
                let dataParser = DataParser()
                let fish = dataParser.parseFish(json)
                fishReceived(fish)
            }
            else {
                if let data = data {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "")
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
