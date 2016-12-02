//
//  NavigationCoordinator.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 29/11/2016.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import Foundation

class NavigationCoordinator {

    func navigate(departure: CLLocationCoordinate2D, destC: CLLocationCoordinate2D) {
        let googleUrl = googleMapsURL(withDeparture: departure, destination: destC)
        if let url = googleUrl, canOpenURL(url) {
            UIApplication.shared.openURL(url)
        } else {
            let appleUrl = appleMapsURL(withDeparture: departure, destination: destC)
            if let url = appleUrl, canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }

    fileprivate func canOpenURL(_ url: URL?) -> Bool {
        if let url = url {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }

    func appleMapsURL(withDeparture departure: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> URL? {
        return URL(string: "https://maps.apple.com?saddr=\(departure.latitude),\(departure.longitude)&daddr=\(destination.latitude),\(destination.longitude)")
    }

    func googleMapsURL(withDeparture departure: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> URL? {
        return combineUrl(
            URL(string: "comgooglemaps://"),
            withQuery: "saddr=\(departure.latitude),\(departure.longitude)&daddr=\(destination.latitude),\(destination.longitude)")
    }

    func combineUrl(_ url: URL?, withQuery query: String) -> URL? {
        guard let url = url else { return nil }

        var comp = URLComponents(url: url, resolvingAgainstBaseURL: true)
        comp?.query = query
        return comp?.url
    }
}
