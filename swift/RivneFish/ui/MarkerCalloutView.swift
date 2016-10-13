//
//  MarkerCalloutView.swift
//  RivneFish
//
//  Created by Anatoliy Kyryliuk on 11/5/15.
//  Copyright © 2015 rivnefish. All rights reserved.
//

import UIKit

class MarkerCalloutView : UIView {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var nameLabelHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var arrowIconRightMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowIconLeftMarginConstraint: NSLayoutConstraint!

    func updateWidth() {
        let nameWidth = self.nameLabel.intrinsicContentSize.width
        let margin = CGFloat(20.0)
        var width = nameWidth + (arrowIcon.frame.width + arrowIconRightMarginConstraint.constant + arrowIconLeftMarginConstraint.constant)
        let maxWidth = UIScreen.main.bounds.width - margin * 2

        if width > maxWidth {
            width = maxWidth
        }

        var frame = self.frame
        frame.size.width = width
        // Do not update height for now
        // frame.size.height = height
        self.frame = frame
        
        self.layoutIfNeeded()
    }
}
