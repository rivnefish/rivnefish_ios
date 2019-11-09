//
//  ImageViewCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 01/05/2017.
//  Copyright © 2017 rivnefish. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = nil
    }

    var image: UIImage? {
        return imageView.image
    }

    func updateCell(withImage image: UIImage?) {
        if let image = image {
            imageView.image = image
            loadingIndicator.isHidden = true
        } else {
            imageView.image = nil
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        }
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
}
