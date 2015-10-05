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
    @IBOutlet weak var nameLabelView: UILabel!

    var image: UIImage?
    var name: String?
    var amount: Int = 0

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func updateCell() {
        imageView.image = image
        nameLabelView.text = name
        progressView.progress = Float(amount) / 10.0
    }
}
