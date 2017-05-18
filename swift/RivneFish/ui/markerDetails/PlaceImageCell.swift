//
//  PlaceImageCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 18/05/2017.
//  Copyright © 2017 rivnefish. All rights reserved.
//

import UIKit

class PlaceImageCell: UITableViewCell {
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    private var selectCellAction: EmptyClosure?

    override func awakeFromNib() {
        super.awakeFromNib()
        placeImageView.image = nil
    }

    func setup(withImage image: UIImage?, selectCellAction: EmptyClosure?) {
        self.selectCellAction = selectCellAction
        if let image = image {
            placeImageView.image = image
            loadingIndicator.isHidden = true
        } else {
            placeImageView.image = nil
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        }
    }

    @IBAction func actionButtonPressed() {
        selectCellAction?()
    }

    override func prepareForReuse() {
        placeImageView.image = nil
    }
}
