//
//  ModifiedDateCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class ModifiedDateCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!

    func setupWithText(_ text: String?) {
        self.contentLabel.text = text ?? ""
    }
}
