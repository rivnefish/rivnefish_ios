//
//  AddressCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class AddressCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var coordinatesTextEdit: UITextField!
    @IBOutlet weak var addressVConstraint: NSLayoutConstraint!

    @IBOutlet weak var coordinatesVConstraint: NSLayoutConstraint!
    func setup(withName name: String?, address: String? ,coordinates: String?) {
        if let name = name {
            captionLabel.text = name
        } else {
            captionLabel.text = ""
        }
        if let address = address {
            addressLabel.text = address
        } else {
            addressLabel.text = ""
            addressVConstraint.constant = 0
        }
        if let coordinates = coordinates {
            coordinatesTextEdit.text = coordinates
        } else {
            coordinatesTextEdit.text = ""
            coordinatesVConstraint.constant = 0
        }
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
}
