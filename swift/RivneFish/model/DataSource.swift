//
//  DataSource.swift
//  RivneFish
//
//  Created by akyryl on 20/06/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit

let placesUrl = DataSource.kHost + "/api/v1/places"
let fishUrl = DataSource.kHost + "/api/v1/fish"

class DataSource: NSObject {

    static let kHost = "http://new.rivnefish.com"

    func places(_ rechability: Reach, completionHandler: @escaping (_ markers: Array<Place>?) -> Void) {
        // If there is online connection
        if rechability.currentReachabilityStatus() != NetworkStatus.NotReachable {
            // Check if marker list is up to date

            ActualityValidator.actualityValidator.checkPlaces({ (outdated: Bool) in
                // If it is oudated
                if outdated {
                    // Remove all places from cache, so we will need to request new one
                    self.removePlacesFromCache()
                }

                // Request places, try from cache, if no, try from netowrk
                self.placesFromCache() { placesArr in
                    if let places = placesArr {
                        DispatchQueue.main.async(execute: {
                            completionHandler(places)
                        })
                    } else {
                        // If there is no places in cache - request it
                        self.requestPlacesFromNetwork(completionHandler: completionHandler)
                    }
                }
            })
        } else {
            // if there is no connection - take data from cache
            self.placesFromCache() { places in
                DispatchQueue.main.async(execute: {
                    completionHandler(places)
                })
            }
        }
    }

    private func requestPlacesFromNetwork(completionHandler: @escaping (_ markers: Array<Place>?) -> Void) {
        NetworkDataSource.sharedInstace.places({ (placesArr: Array<Place>?) in
            if let places = placesArr {
                self.savePlacesToCache(places: places)
                ActualityValidator.actualityValidator.updatePlacesLastChangesDate()
            }

            DispatchQueue.main.async(execute: {
                completionHandler(placesArr)
            })
        })
    }

    func savePlacesToCache(places: Array<Place>) {
        TMCache.shared().setObject(places as NSArray, forKey: placesUrl)
    }

    func savePlaceDetailsToCache(placeDetails: PlaceDetails) {
        let placeKey = "placeDetails:" + String(placeDetails.markerID)
        TMCache.shared().setObject(placeDetails, forKey: placeKey)
    }

    func removePlacesFromCache() {
        TMCache.shared().removeObject(forKey: placesUrl)
    }

    func placesFromCache(handler: @escaping (Array<Place>?) -> Void) {
        let placesKey = "places"

        TMCache.shared().object(forKey: placesKey) { (cache, key, object) in
            if let nsArr = TMCache.shared().object(forKey: placesKey) as? NSArray,
                let arr = nsArr as? Array<Place> {
                return handler(arr)
            }
            return handler(nil)
        }
    }

    func placeDetailsFromCache(id: Int, handler: @escaping (PlaceDetails?) -> Void) {
        let placeKey = "placeDetails:" + String(id)
        TMCache.shared().object(forKey: placeKey) { (cache, key, object) in
            handler(object as? PlaceDetails)
        }
    }

    func placeDetails(rechability: Reach, place: Place, completionHandler: @escaping (_ placeDetails: PlaceDetails?, _ cached: Bool) -> Void) {
        placeDetailsFromCache(id: place.id) { cachedPlaceDetails in

            var isPlaceUpToDate = false
            if let details = cachedPlaceDetails {
                isPlaceUpToDate = ActualityValidator.actualityValidator.isUpToDate(cachedPlaceDetails: details, with: place)
            }

            if isPlaceUpToDate || rechability.currentReachabilityStatus() == .NotReachable {
                DispatchQueue.main.async(execute: {
                    completionHandler(cachedPlaceDetails, isPlaceUpToDate)
                })
            } else {
                self.requestPlaceDetailsFromNetwork(id: place.id, storeToCache: !isPlaceUpToDate, completionHandler: completionHandler)
            }

        }
    }

    private func requestPlaceDetailsFromNetwork(id: Int, storeToCache: Bool, completionHandler: @escaping (_ placeDetails: PlaceDetails?, _ cached: Bool) -> Void) {
        NetworkDataSource.sharedInstace.placeDetails(id: id) { placeDetails in
            if let details = placeDetails {
                if storeToCache {
                    self.savePlaceDetailsToCache(placeDetails: details)
                }
                DispatchQueue.main.async(execute: {
                    completionHandler(details, !storeToCache)
                })
            }
        }
    }

    func allFish(rechability: Reach, completionHandler: @escaping (_ fish: Array<Fish>?) -> Void) {
        if rechability.currentReachabilityStatus() != NetworkStatus.NotReachable {
            ActualityValidator.actualityValidator.checkFish({ (outdated: Bool) in
                if outdated {
                    self.allFishFromNetwork(handler: completionHandler)
                } else {
                    self.allFishFromCache() { cachedFish in
                        if cachedFish != nil {
                            completionHandler(cachedFish)
                        } else {
                            self.allFishFromNetwork(handler: completionHandler)
                        }
                    }
                }
            })
        } else {
            self.allFishFromNetwork(handler: completionHandler)
        }
    }

    private func allFishFromNetwork(handler: @escaping (_ fish: Array<Fish>?) -> Void) {
        NetworkDataSource.sharedInstace.fishAll(fishReceived: { (fishArr: Array<Fish>?) in
            if let fish = fishArr {
                self.saveAllFishToCache(fish: fish)
                ActualityValidator.actualityValidator.updateFishLastChangesDate()
                handler(fish)
            } else {
                handler(nil)
            }
        })
    }

    private func allFishFromCache(handler: @escaping (_ fish: Array<Fish>?) -> Void) {
        TMCache.shared().object(forKey: fishUrl) { (cache, key, object) in
            handler(object as? Array<Fish>)
        }
    }

    private func saveAllFishToCache(fish: Array<Fish>) {
        TMCache.shared().setObject(fish as NSArray, forKey: fishUrl)
    }

    /*func fishForMarker(fromCache: Bool, _ rechability: Reach, placeId: Int, completionHandler: @escaping (_ fish: Array<Fish>?) -> Void) {
        if fromCache {
            fishFromCache(placeId: placeId) { cachedFish in
                if cachedFish != nil {
                    completionHandler(cachedFish)
                } else {
                    self.sortedFishFromNetwork(placeId: placeId, saveToCache: true, handler: completionHandler)
                }
            }
        } else {
            self.sortedFishFromNetwork(placeId: placeId, saveToCache: true, handler: completionHandler)
        }
    }

    private func sortedFishFromNetwork(placeId: Int, saveToCache: Bool, handler: @escaping (_ fish: Array<Fish>?) -> Void) {
        NetworkDataSource.sharedInstace.fishForMarkerID(placeId, fishReceived: { (fishArr: Array<Fish>?) in
            if let fish = fishArr {
                let sortedFish = self.sortedFishArray(fish)
                if saveToCache {
                    self.saveFishToCache(placeId: placeId, fish: sortedFish)
                }
                handler(sortedFish)
            } else {
                handler(nil)
            }
        })
    }

    private func saveFishToCache(placeId: Int, fish: Array<Fish>) {
        let fishCacheId = "Fish:" + String(placeId)
        TMCache.shared().setObject(fish as NSArray, forKey: fishCacheId)
    }

    private func fishFromCache(placeId: Int, handler: @escaping (_ fish: Array<Fish>?) -> Void) {
        let fishCacheId = "Fish:" + String(placeId)
        TMCache.shared().object(forKey: fishCacheId) { (cache, key, object) in
            if let arr = object as? Array<Fish> {
                handler(self.sortedFishArray(arr))
            } else {
                handler(nil)
            }
        }
    }

    private func sortedFishArray(_ fish: Array<Fish>) -> Array<Fish> {
        return fish.sorted {
            return $0.amount ?? 0 < $1.amount ?? 0
        }
    }*/

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
