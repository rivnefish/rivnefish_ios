//
//  ImagesCollectionViewCell.swift
//  RivneFish
//
//  Created by akyryl on 09/09/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit

class ImagesCollectionViewCell : UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func updateCell() {
        imageView.image = self.image
    }
}
