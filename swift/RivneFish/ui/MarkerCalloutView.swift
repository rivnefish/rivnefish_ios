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
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var nameLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressLabelHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var arrowIconRightMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowIconLeftMarginConstraint: NSLayoutConstraint!

    func updateWidth() {
        let addressWidth = self.addressLabel.intrinsicContentSize().width
        let nameWidth = self.nameLabel.intrinsicContentSize().width

        let nameHeight = nameLabelHeightConstraint.constant
        let addressHeight = self.addressLabel.text?.characters.count > 0 ? addressLabelHeightConstraint.constant : 0

        let margin = CGFloat(20.0)
        var width = max(addressWidth, nameWidth) + (arrowIcon.frame.width + arrowIconRightMarginConstraint.constant + arrowIconLeftMarginConstraint.constant)
        let maxWidth = UIScreen.mainScreen().bounds.width - margin * 2

        if width > maxWidth {
            width = maxWidth
        }
        let height = nameHeight + addressHeight
        
        var frame = self.frame
        frame.size.width = width
        // Do not update height for now
        // frame.size.height = height
        self.frame = frame
        
        self.layoutIfNeeded()
    }
}
