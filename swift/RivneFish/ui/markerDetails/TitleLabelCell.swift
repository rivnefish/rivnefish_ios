//
//  TitleLabelCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class TitleLabelCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var label: UILabel!

    func setup(withTitle title: String?, text: String?) {
        if let title = title, !title.isEmpty {
            self.title.text = title
        } else {
            self.title.isHidden = true
        }

        if let text = text, !text.isEmpty {
            self.label.text = text
        } else {
            self.label.isHidden = true
        }
    }
}
