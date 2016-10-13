//
//  ImagesCollectionViewCell.swift
//  RivneFish
//
//  Created by akyryl on 09/09/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit

class ImagesCollectionViewCell : UICollectionViewCell {

    @IBOutlet weak var bluredImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    fileprivate var image: UIImage?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func updateCell(withImage image: UIImage?) {
        self.image = image
        if let image = self.image {
            bluredImage.image = image
            imageView.image = image
            loadingIndicator.isHidden = true
        } else {
            bluredImage.image = nil
            imageView.image = nil
            loadingIndicator.isHidden = false
        }
    }
}
