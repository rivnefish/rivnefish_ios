//
//  MarkerAndAnnotation.swift
//  RivneFish
//
//  Created by Anatoliy Kyryliuk on 10/24/15.
//  Copyright © 2015 rivnefish. All rights reserved.
//

import MapKit

class PlaceMarker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var place: Place

    init(place: Place) {
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(place.lat), longitude: CLLocationDegrees(place.lon))
        self.title = place.name

        self.place = place
    }
}

class PlaceMarkerAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            image = UIImage(named: "marker")
            clusteringIdentifier = "marker"
        }
    }
}

class ClusterAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "marker"

            let count = (annotation as? MKClusterAnnotation )?.memberAnnotations.count ?? 0
            image = generateClusterIconWithCount(count: count)
        }
    }

    func generateClusterIconWithCount(count: Int) -> UIImage? {
        let diameter: CGFloat = 30.0
        let inset: CGFloat = 1.0

        let rect = CGRect(x: 0, y: 0, width: diameter + 10, height: diameter + 10)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }

        // draw shadow
        ctx.saveGState()
        ctx.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
        UIColor.white.setFill()
        let shadowRect = CGRect(x: 0, y: 0, width: diameter, height: diameter)

        ctx.fillEllipse(in: shadowRect)
        ctx.restoreGState()

        // set stroking color and draw circle
        UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).setStroke()
        backClusterColor(for: count).setFill()

        ctx.setLineWidth(inset)

        // make circle rect 5 px from border
        let circleRect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        circleRect.insetBy(dx: inset, dy: inset)

        // draw circle
        ctx.fillEllipse(in: circleRect)
        ctx.strokeEllipse(in: circleRect)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let font: UIFont = UIFont.systemFont(ofSize: fontSize(for: count))
        let attrs = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.white]

        let string = String(count)
        let textRect = CGRect(
            x: 0,
            y: diameter / 2 - font.lineHeight / 2,
            width: diameter,
            height: diameter)
        string.draw(with: textRect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    private func fontSize(for childMarkersCount: Int) -> CGFloat {
        let fontSize: CGFloat
        if childMarkersCount > 999 {
            fontSize = 11
        } else if childMarkersCount > 99 {
            fontSize = 12
        } else if childMarkersCount > 9 {
            fontSize = 13
        } else {
            fontSize = 14
        }
        return fontSize
    }

    private func backClusterColor(for childMarkersCount: Int) -> UIColor {
        let color: UIColor
        let yellow = UIColor(red: 1.0, green: 180.0 / 255.0, blue: 0, alpha: 1.0)
        let orange = UIColor(red: 253.0 / 255.0, green: 128.0 / 255.0, blue:35.0 / 255.0, alpha:1.0)
        let blue = UIColor(red: 92.0 / 255.0, green:115.0 / 255.0, blue: 201.0 / 255.0, alpha:1.0)

        if childMarkersCount > 100 {
            color = yellow
        } else if childMarkersCount > 10 {
            color = orange
        } else {
            color = blue
        }
        return color
    }
}
