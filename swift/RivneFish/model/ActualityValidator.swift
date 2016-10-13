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
    var serverLastChanges = NSNumber()

    static let kLastChangesKey = "LastChanges"

    func checkMarkers(_ completionHandler: @escaping (_ isOutdated: Bool) -> Void) {
        NetworkDataSource.sharedInstace.lastChanges({ (lastChanges: NSNumber) in
            var outdated = true
            let defaults = UserDefaults.standard
            self.serverLastChanges = lastChanges

            let lastSavedNum = defaults.object(forKey: ActualityValidator.kLastChangesKey)
            if let savedNum = lastSavedNum , (savedNum as AnyObject).isEqual(self.serverLastChanges) {
                outdated = false
            }
            completionHandler(outdated)
        })
    }

    func markerUpToDate(_ marker: MarkerModel) -> Bool {
        var upToDate = false
        let defaults = UserDefaults.standard
        let date: String? = defaults.object(forKey: marker.markerID.stringValue) as? String
        if let savedDate = date, let currentDate = marker.modifyDate {
            upToDate = (savedDate.compare(currentDate) == .orderedSame)
        }
        return upToDate
    }

    func updateUserLastChangesDate() {
        let defaults = UserDefaults.standard
        defaults.setValue(self.serverLastChanges, forKey: ActualityValidator.kLastChangesKey)
    }
}
