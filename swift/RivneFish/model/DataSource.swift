//
//  DataSource.swift
//  RivneFish
//
//  Created by akyryl on 20/06/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit

class DataSource: NSObject {

    func allAvailableMarkers(_ rechability: Reach, completionHandler: @escaping (_ markers: NSArray) -> Void) {
        let urlStr = "http://api.rivnefish.com/markers/"

        // If there is online connection
        if rechability.currentReachabilityStatus() != NetworkStatus.NotReachable {
            // Check if marker list is up to date

            ActualityValidator.actualityValidator.checkMarkers({ (outdated: Bool) in
                // If it is oudated
                if outdated {
                    // Remove value from cache, so we will need to request new one
                    TMCache.shared().removeObject(forKey: urlStr)
                }

                // Request new data, try from cache, if no, try from netowrk
                TMCache.shared().object(forKey: urlStr) { (cache, key, object) in
                    if let markers = object as? NSArray {
                        if markers.count != 0 {
                            DispatchQueue.main.async(execute: {
                                completionHandler(markers)
                            })
                        }

                    } else {
                        // If there is no markers in cache - request it
                        NetworkDataSource.sharedInstace.allAvailableMarkers({ (markers: NSArray) in
                            if markers.count != 0 {
                                TMCache.shared().setObject(markers, forKey: urlStr)
                                self.saveMarkersIdAndModifyDate(markers)

                                // Update last changes num
                                ActualityValidator.actualityValidator.updateUserLastChangesDate()

                                DispatchQueue.main.async(execute: {
                                    completionHandler(markers)
                                })
                            }
                        })
                    }
                }
            })
        } else {
            // if there is no connection - take data from cache
            TMCache.shared().object(forKey: urlStr) { (cache, key, object) in
                if let markers = object as? NSArray {
                    if markers.count != 0 {
                        DispatchQueue.main.async(execute: {
                            completionHandler(markers)
                        })
                    }
                }
            }
        }
    }

    func saveMarkersIdAndModifyDate(_ markers: NSArray) {
        let defaults = UserDefaults.standard
        let markersArr = markers as! Array<MarkerModel>
        for marker: MarkerModel in markersArr {
            defaults.set(marker.modifyDate, forKey: marker.markerID.stringValue)
        }
    }

    func removeMarkerCachedImages(_ marker: MarkerModel) {
        let imgUrlsArr = marker.photoUrls
        if let urls = imgUrlsArr {
            for imgUrl in urls {
                TMCache.shared().removeObject(forKey: imgUrl)
            }
        }
    }

    func fishForMarker(_ rechability: Reach, marker: MarkerModel, completionHandler: @escaping (_ fish: NSArray) -> Void) {
        // if marker is outdated - remove fish from cache
        var requestFromNetwork = false
        let markerId = marker.markerID.stringValue
        let fishCacheId = "Fish:" + marker.markerID.stringValue
        if rechability.currentReachabilityStatus() != NetworkStatus.NotReachable &&
            false == ActualityValidator.actualityValidator.markerUpToDate(marker)
        {
            TMCache.shared().removeObject(forKey: fishCacheId)
            requestFromNetwork = true
        }

        if requestFromNetwork {
            // request directly from network
            NetworkDataSource.sharedInstace.fishForMarkerID(markerId, fishReceived: { (fish: NSArray) in
                // save to cache
                let sortedFish = self.sortedFishArray(fish)
                if sortedFish.count > 0 {
                    TMCache.shared().setObject(sortedFish, forKey: fishCacheId)
                }
                DispatchQueue.main.async(execute: {
                    completionHandler(sortedFish)
                })
            })
        } else {
            // try to request from cache
            TMCache.shared().object(forKey: fishCacheId) { (cache, key, object) in
                if let fish = object as? NSArray {
                    if fish.count != 0 {
                        // TODO: sort temporary, untill not sorted fish in cache
                        let sortedFish = self.sortedFishArray(fish)
                        DispatchQueue.main.async(execute: {
                            completionHandler(sortedFish)
                        })
                    }
                } else { // if no data in cache - request from network
                    NetworkDataSource.sharedInstace.fishForMarkerID(markerId, fishReceived: { (fish: NSArray) in
                        // save to cache
                        let sortedFish = self.sortedFishArray(fish)
                        if fish.count > 0 {
                            TMCache.shared().setObject(sortedFish, forKey: fishCacheId)
                        }
                        DispatchQueue.main.async(execute: {
                            completionHandler(sortedFish)
                        })
                    })
                }
            }
        }
    }

    func sortedFishArray(_ fish: NSArray) -> NSArray {
        return fish.sortedArray (comparator: {
            (obj1, obj2) -> ComparisonResult in

            if let f1 = obj1 as? Fish,
                let f2 = obj2 as? Fish {
                return f1.compare(f2)
            }
            return ComparisonResult.orderedSame
        }) as NSArray
    }

    func loadImages(_ urlsArr: Array<String>?, completionHandler: @escaping ((String, UIImage?) -> Void)) {
        if let urlStringArr = urlsArr {
            var i: Int = 0
            for urlString in urlStringArr {
                // Read from cache
                TMCache.shared().object(forKey: urlString) { (cache, key, object) in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async(execute: {
                            completionHandler(urlString, image)
                        })
                    } else {
                        // If there is no image in cache - request it
                        if let url = URL(string: urlString) {
                            NetworkDataSource.sharedInstace.getDataFromUrl(url) { data, index in
                                if let data = try? Data(contentsOf: url) {
                                    TMCache.shared().setObject(UIImage(data: data), forKey: urlString)
                                    DispatchQueue.main.async(execute: {
                                        completionHandler(urlString, UIImage(data: data))
                                    })
                                } else {
                                    DispatchQueue.main.async(execute: {
                                        completionHandler(urlString, UIImage(named: "no_image"))
                                    })
                                }
                            }
                        }
                    }
                }
                i += 1
            }
        }
    }
}
