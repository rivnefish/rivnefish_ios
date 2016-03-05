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

    func checkMarkers(completionHandler: (isOutdated: Bool) -> Void) {
        NetworkDataSource.sharedInstace.lastChanges({ (lastChanges: NSNumber) in
            var outdated = true
            let defaults = NSUserDefaults.standardUserDefaults()
            self.serverLastChanges = lastChanges

            let lastSavedNum = defaults.objectForKey(ActualityValidator.kLastChangesKey)
            if let savedNum = lastSavedNum where savedNum.isEqual(self.serverLastChanges) {
                outdated = false
            }
            completionHandler(isOutdated: outdated)
        })
    }

    func markerUpToDate(marker: MarkerModel) -> Bool {
        var upToDate = false
        let defaults = NSUserDefaults.standardUserDefaults()
        let date: String? = defaults.objectForKey(marker.markerID.stringValue) as? String
        if let savedDate = date, currentDate = marker.modifyDate {
            upToDate = (savedDate.compare(currentDate) == .OrderedSame)
        }
        return upToDate
    }

    func updateUserLastChangesDate() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(self.serverLastChanges, forKey: ActualityValidator.kLastChangesKey)
    }
}
