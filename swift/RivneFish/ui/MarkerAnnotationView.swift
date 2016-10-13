//
//  MarkerAnnotationView.swift
//  RivneFish
//
//  Created by akyryl on 27/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import MapKit
import UIKit

class MarkerAnnotationView : MKAnnotationView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemsCountLabel: UILabel!
    var itemsCount: Int = 1

    class func instanceFromNib(_ countElements: Int = 1) -> MarkerAnnotationView {
        let view: MarkerAnnotationView = UINib(nibName: "MarkerAnnotationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MarkerAnnotationView

        view.itemsCount = countElements
        view.updateImageAndText()
        return view
    }

    func updateImageAndText() {
        var imagePath = ""
        if self.itemsCount > 99 {
            imagePath = "m100-"
        } else if self.itemsCount > 9 {
            imagePath = "m10-99"
        } else if self.itemsCount > 1 {
            imagePath = "m2-9"
        } else {
            imagePath = "m1"
        }
        self.imageView.image = UIImage(named: imagePath)
        self.itemsCountLabel.text = self.itemsCount > 1 ? String(self.itemsCount) : ""

        if self.itemsCount == 0 {
            self.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        } else {
            self.rightCalloutAccessoryView = nil
        }
    }
}
