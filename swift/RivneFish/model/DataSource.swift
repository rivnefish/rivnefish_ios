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

    func allAvailableMarkers(rechability: Reach, completionHandler: (markers: NSArray) -> Void) {
        let urlStr = "http://api.rivnefish.com/markers/"

        // If there is online connection
        if rechability.currentReachabilityStatus() != NetworkStatus.NotReachable {
            // Check if marker list is up to date

            ActualityValidator.actualityValidator.checkMarkers({ (outdated: Bool) in
                // If it is oudated
                if outdated {
                    // Remove value from cache, so we will need to request new one
                    TMCache.sharedCache().removeObjectForKey(urlStr)
                }

                // Request new data, try from cache, if no, try from netowrk
                TMCache.sharedCache().objectForKey(urlStr) { (cache, key, object) in
                    if let markers = object as? NSArray {
                        if markers.count != 0 {
                            completionHandler(markers: markers)
                        }

                    } else {
                        // If there is no markers in cache - request it
                        NetworkDataSource.sharedInstace.allAvailableMarkers({ (markers: NSArray) in
                            if markers.count != 0 {
                                TMCache.sharedCache().setObject(markers, forKey: urlStr)

                                // Update last changes num
                                ActualityValidator.actualityValidator.updateUserLastChangesDate()

                                completionHandler(markers: markers)
                            }
                        })
                    }
                }
            })
        } else {
            // if there is no connection - take data from cache
            TMCache.sharedCache().objectForKey(urlStr) { (cache, key, object) in
                if let markers = object as? NSArray {
                    if markers.count != 0 {
                        completionHandler(markers: markers)
                    }
                }
            }
        }
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

    func loadImages(urlsArr: Array<String>?, completionHandler: ((String, UIImage?) -> Void)) {
        if let urlStringArr = urlsArr {
            var i: Int = 0
            for urlString in urlStringArr {
                // Read from cache
                TMCache.sharedCache().objectForKey(urlString) { (cache, key, object) in
                    if let image = object as? UIImage {
                        completionHandler(urlString, image)
                    } else {
                        // If there is no image in cache - request it
                        if let url = NSURL(string: urlString) {
                            self.getDataFromUrl(url) { data, index in
                                if let data = NSData(contentsOfURL: url) {
                                    TMCache.sharedCache().setObject(UIImage(data: data), forKey: urlString)
                                    completionHandler(urlString, UIImage(data: data))
                                }
                            }
                        }
                    }
                }
                ++i
            }
        }
    }

    func getDataFromUrl(urL: NSURL, completion: ((data: NSData?, url: String) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data, url: urL.absoluteString)
            }.resume()
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
