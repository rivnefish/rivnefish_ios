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
    var serverLastChanges = 0

    static let kPlacesLastChangesKey = "PlacesLastChanges"
    static let kFishLastChangesKey = "FishLastChanges"

    func checkPlaces(_ completionHandler: @escaping (_ isOutdated: Bool) -> Void) {
        NetworkDataSource.sharedInstace.placesLastChanges({ (lastChanges: Int) in
            var outdated = true
            let defaults = UserDefaults.standard
            self.serverLastChanges = lastChanges

            let lastSavedNum = defaults.integer(forKey: ActualityValidator.kPlacesLastChangesKey)
            if lastSavedNum == self.serverLastChanges {
                outdated = false
            }
            completionHandler(outdated)
        })
    }

    func checkFish(_ completionHandler: @escaping (_ isOutdated: Bool) -> Void) {
        NetworkDataSource.sharedInstace.fishLastChanges({ (lastChanges: Int) in
            var outdated = true
            let defaults = UserDefaults.standard
            self.serverLastChanges = lastChanges

            let lastSavedNum = defaults.integer(forKey: ActualityValidator.kFishLastChangesKey)
            if lastSavedNum == self.serverLastChanges {
                outdated = false
            }
            completionHandler(outdated)
        })
    }

    /*func markerUpToDate(_ marker: MarkerModel) -> Bool {
        var upToDate = false
        let defaults = UserDefaults.standard
        let date: String? = defaults.string(forKey: String(marker.markerID))
        if let savedDate = date, let currentDate = marker.modifyDate {
            upToDate = (savedDate.compare(currentDate) == .orderedSame)
        }
        return upToDate
    }*/

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
        defaults.set(self.serverLastChanges, forKey: ActualityValidator.kPlacesLastChangesKey)
    }

    func updateFishLastChangesDate() {
        let defaults = UserDefaults.standard
        defaults.set(self.serverLastChanges, forKey: ActualityValidator.kFishLastChangesKey)
    }
}
