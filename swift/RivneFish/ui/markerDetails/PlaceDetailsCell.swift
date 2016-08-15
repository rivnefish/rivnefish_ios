//
//  PlaceDetailsCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import Foundation

class PlaceDetailsCell: UITableViewCell {

    @IBOutlet weak var squareLabel: UILabel!
    @IBOutlet weak var averageDepthLabel: UILabel!
    @IBOutlet weak var maxDepthLabel: UILabel!
    @IBOutlet weak var squareCaptionLabel: UILabel!
    @IBOutlet weak var averageDepthCaptionLabel: UILabel!
    @IBOutlet weak var maxDepthCaptionLabel: UILabel!

    @IBOutlet weak var squareLabelVConstraint: NSLayoutConstraint!
    @IBOutlet weak var averageDepthVConstraint: NSLayoutConstraint!
    @IBOutlet weak var maxDepthVConstraint: NSLayoutConstraint!
    
    func setup(withSquare square: String?, averageDepth: String?, maxDepth: String?) {
        let square = square ?? ""
        if !square.isEmpty {
            squareLabel.text = square
        } else {
            squareLabel.text = ""
            squareCaptionLabel.text = ""
            squareLabelVConstraint.constant = 0
        }

        let averageDepth = averageDepth ?? ""
        if !averageDepth.isEmpty {
            averageDepthLabel.text = averageDepth
        } else {
            averageDepthLabel.text = ""
            averageDepthCaptionLabel.text = ""
            averageDepthVConstraint.constant = 0
        }

        let maxDepth = maxDepth ?? ""
        if !maxDepth.isEmpty {
            maxDepthLabel.text = maxDepth
        } else {
            maxDepthLabel.text = ""
            maxDepthCaptionLabel.text = ""
            maxDepthVConstraint.constant = 0
        }
    }
}
