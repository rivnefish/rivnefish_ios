//
//  AddressCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressVConstraint: NSLayoutConstraint!
    @IBOutlet weak var coordinatesTextView: UITextView!
    @IBOutlet weak var coordinatesVConstraint: NSLayoutConstraint!

    func setup(withName name: String?, address: String? ,coordinates: String?) {
        if let name = name {
            captionLabel.text = name
        } else {
            captionLabel.text = ""
        }
        let address = address ?? ""
        if !address.isEmpty {
            addressLabel.text = address
        } else {
            addressLabel.text = ""
            addressVConstraint.constant = 0
        }
        let coordinates = coordinates ?? ""
        if !coordinates.isEmpty {
            coordinatesTextView.text = coordinates
        } else {
            coordinatesTextView.text = ""
            coordinatesVConstraint.constant = 0
        }
    }
}
