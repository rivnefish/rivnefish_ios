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

    static let kLastChangesKey = "LastChanges"

    func checkMarkers(_ completionHandler: @escaping (_ isOutdated: Bool) -> Void) {
        NetworkDataSource.sharedInstace.lastChanges({ (lastChanges: Int) in
            var outdated = true
            let defaults = UserDefaults.standard
            self.serverLastChanges = lastChanges

            let lastSavedNum = defaults.integer(forKey: ActualityValidator.kLastChangesKey)
            if lastSavedNum == self.serverLastChanges {
                outdated = false
            }
            completionHandler(outdated)
        })
    }

    func markerUpToDate(_ marker: MarkerModel) -> Bool {
        var upToDate = false
        let defaults = UserDefaults.standard
        let date: String? = defaults.string(forKey: String(marker.markerID))
        if let savedDate = date, let currentDate = marker.modifyDate {
            upToDate = (savedDate.compare(currentDate) == .orderedSame)
        }
        return upToDate
    }

    func updateUserLastChangesDate() {
        let defaults = UserDefaults.standard
        defaults.set(self.serverLastChanges, forKey: ActualityValidator.kLastChangesKey)
    }
}
