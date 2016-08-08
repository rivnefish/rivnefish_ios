//
//  ContactsCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class ContactsCell: UITableViewCell {

    @IBOutlet weak var phoneCaptionLabel: UILabel!
    @IBOutlet weak var phoneCaptionVConstraint: UILabel!

    @IBOutlet weak var phoneVConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneButton: UIButton!

    @IBOutlet weak var phoneHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsLabel: UILabel!

    @IBAction func phonePressed(sender: UIButton) {
        // TODO: open phone
    }

    func setup(withPhone phone: String?, details: String?) {
        if let phone = phone where phone.isEmpty == false {
            phoneButton.setTitle(phone, forState: UIControlState.Normal)
        } else {
            phoneCaptionLabel.text = ""
            phoneVConstraint.constant = 0
            phoneButton.titleLabel?.text = ""
            phoneHeightConstraint.constant = 0
            phoneVConstraint.constant = 0
        }
        if let details = details {
            detailsLabel.text = details
        } else {
            detailsLabel.text = ""
            detailsConstraint.constant = 0
        }
    }
}
