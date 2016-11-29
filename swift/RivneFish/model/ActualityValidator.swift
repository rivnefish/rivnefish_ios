//
//  ActualityValidator.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 28/02/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import Foundation

class ActualityValidator {
    static var actualityValidator = ActualityValidator()
    var serverMarkersHash: String? = nil
    var serverFishHash: String? = nil

    func checkPlaces(_ completionHandler: @escaping (_ isOutdated: Bool) -> Void) {
        NetworkDataSource.sharedInstace.placesLastChanges({ (lastChanges: String?) in
            var outdated = true
            let defaults = UserDefaults.standard
            self.serverMarkersHash = lastChanges

            let lastSavedHash = defaults.string(forKey: Constants.Cache.kPlacesLastChangesKey)
            if let serverHash = self.serverMarkersHash, serverHash == lastSavedHash {
                outdated = false
            }
            completionHandler(outdated)
        })
    }

    func checkFish(_ completionHandler: @escaping (_ isOutdated: Bool) -> Void) {
        NetworkDataSource.sharedInstace.fishLastChanges({ (lastChanges: String?) in
            var outdated = true
            let defaults = UserDefaults.standard
            self.serverFishHash = lastChanges

            let lastSavedHash = defaults.string(forKey: Constants.Cache.kFishLastChangesKey)
            if let severChanges = self.serverFishHash, severChanges == lastSavedHash {
                outdated = false
            }
            completionHandler(outdated)
        })
    }

    func isUpToDate(cachedPlaceDetails: PlaceDetails, with newPlace: Place) -> Bool {
        var upToDate = false

        if let cachedDate = cachedPlaceDetails.modifiedDate,
            let newDate = newPlace.date {
            upToDate = (cachedDate.compare(newDate) == .orderedSame)
        }
        return upToDate
    }

    func updatePlacesLastChangesDate() {
        let defaults = UserDefaults.standard
        if let hash = serverMarkersHash {
            defaults.set(hash, forKey: Constants.Cache.kPlacesLastChangesKey)
        }
    }

    func updateFishLastChangesDate() {
        let defaults = UserDefaults.standard
        if let hash = serverFishHash {
            defaults.set(hash, forKey: Constants.Cache.kFishLastChangesKey)
        }
    }
}
