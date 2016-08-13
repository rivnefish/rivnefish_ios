//
//  DataSource.swift
//  RivneFish
//
//  Created by akyryl on 20/06/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit

class DataSource: NSObject {

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
                            dispatch_async(dispatch_get_main_queue(),{
                                completionHandler(markers: markers)
                            })
                        }

                    } else {
                        // If there is no markers in cache - request it
                        NetworkDataSource.sharedInstace.allAvailableMarkers({ (markers: NSArray) in
                            if markers.count != 0 {
                                TMCache.sharedCache().setObject(markers, forKey: urlStr)
                                self.saveMarkersIdAndModifyDate(markers)

                                // Update last changes num
                                ActualityValidator.actualityValidator.updateUserLastChangesDate()

                                dispatch_async(dispatch_get_main_queue(),{
                                    completionHandler(markers: markers)
                                })
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
                        dispatch_async(dispatch_get_main_queue(),{
                            completionHandler(markers: markers)
                        })
                    }
                }
            }
        }
    }

    func saveMarkersIdAndModifyDate(markers: NSArray) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let markersArr = markers as! Array<MarkerModel>
        for marker: MarkerModel in markersArr {
            defaults.setObject(marker.modifyDate, forKey: marker.markerID.stringValue)
        }
    }

    func removeMarkerCachedImages(marker: MarkerModel) {
        let imgUrlsArr = marker.photoUrls
        if let urls = imgUrlsArr {
            for imgUrl in urls {
                TMCache.sharedCache().removeObjectForKey(imgUrl)
            }
        }
    }

    func fishForMarker(rechability: Reach, marker: MarkerModel, completionHandler: (fish: NSArray) -> Void) {
        // if marker is outdated - remove fish from cache
        var requestFromNetwork = false
        let markerId = marker.markerID.stringValue
        let fishCacheId = "Fish:" + marker.markerID.stringValue
        if rechability.currentReachabilityStatus() != NetworkStatus.NotReachable &&
            false == ActualityValidator.actualityValidator.markerUpToDate(marker)
        {
            TMCache.sharedCache().removeObjectForKey(fishCacheId)
            requestFromNetwork = true
        }

        if requestFromNetwork {
            // request directly from network
            NetworkDataSource.sharedInstace.fishForMarkerID(markerId, fishReceived: { (fish: NSArray) in
                // save to cache
                let sortedFish = self.sortedFishArray(fish)
                if sortedFish.count > 0 {
                    TMCache.sharedCache().setObject(sortedFish, forKey: fishCacheId)
                }
                dispatch_async(dispatch_get_main_queue(),{
                    completionHandler(fish: sortedFish)
                })
            })
        } else {
            // try to request from cache
            TMCache.sharedCache().objectForKey(fishCacheId) { (cache, key, object) in
                if let fish = object as? NSArray {
                    if fish.count != 0 {
                        // TODO: sort temporary, untill not sorted fish in cache
                        let sortedFish = self.sortedFishArray(fish)
                        dispatch_async(dispatch_get_main_queue(),{
                            completionHandler(fish: sortedFish)
                        })
                    }
                } else { // if no data in cache - request from network
                    NetworkDataSource.sharedInstace.fishForMarkerID(markerId, fishReceived: { (fish: NSArray) in
                        // save to cache
                        let sortedFish = self.sortedFishArray(fish)
                        if fish.count > 0 {
                            TMCache.sharedCache().setObject(sortedFish, forKey: fishCacheId)
                        }
                        dispatch_async(dispatch_get_main_queue(),{
                            completionHandler(fish: sortedFish)
                        })
                    })
                }
            }
        }
    }

    func sortedFishArray(fish: NSArray) -> NSArray {
        return fish.sortedArrayUsingComparator {
            (obj1, obj2) -> NSComparisonResult in

            if let f1 = obj1 as? Fish,
                let f2 = obj2 as? Fish {
                return f1.compare(f2)
            }
            return NSComparisonResult.OrderedSame
        }
    }

    func loadImages(urlsArr: Array<String>?, completionHandler: ((String, UIImage?) -> Void)) {
        if let urlStringArr = urlsArr {
            var i: Int = 0
            for urlString in urlStringArr {
                // Read from cache
                TMCache.sharedCache().objectForKey(urlString) { (cache, key, object) in
                    if let image = object as? UIImage {
                        dispatch_async(dispatch_get_main_queue(),{
                            completionHandler(urlString, image)
                        })
                    } else {
                        // If there is no image in cache - request it
                        if let url = NSURL(string: urlString) {
                            NetworkDataSource.sharedInstace.getDataFromUrl(url) { data, index in
                                if let data = NSData(contentsOfURL: url) {
                                    TMCache.sharedCache().setObject(UIImage(data: data), forKey: urlString)
                                    dispatch_async(dispatch_get_main_queue(),{
                                        completionHandler(urlString, UIImage(data: data))
                                    })
                                } else {
                                    dispatch_async(dispatch_get_main_queue(),{
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
