//
//  FishCollectionViewCell.swift
//  RivneFish
//
//  Created by Anatoliy Kyryliuk on 10/1/15.
//  Copyright © 2015 rivnefish. All rights reserved.
//

import UIKit

class FishCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!

    var image: UIImage?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func updateCell() {
        imageView.image = image
    }
}
