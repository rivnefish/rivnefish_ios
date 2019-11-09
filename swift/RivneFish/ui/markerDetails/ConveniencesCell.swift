//
//  ConveniencesCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 12/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class ConveniencesCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    func setup(withTitle title: String, text: String?) {
        titleLabel.text = title
        bodyLabel.text = text
    }
}
