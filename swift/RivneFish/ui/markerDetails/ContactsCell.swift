//
//  ContactsCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {
    @IBOutlet weak var contactsTextView: UITextView!
    @IBOutlet weak var phoneCaptionLabel: UILabel!
    @IBOutlet weak var phoneCaptionVConstraint: UILabel!

    @IBOutlet weak var detailsConstraint: NSLayoutConstraint!
    @IBOutlet weak var phonesConstraint: NSLayoutConstraint!
    // @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var detailsTextField: UITextView!

    var phoneNumber: String?

    func setup(contacts: [PlaceContact]?, details: String?) {
        contactsTextView.isUserInteractionEnabled = true
        contactsTextView.isEditable = false
        contactsTextView.isSelectable = true
        contactsTextView.dataDetectorTypes = [.all]
        contactsTextView.isScrollEnabled = false

        detailsTextField.isUserInteractionEnabled = true
        detailsTextField.isEditable = false
        detailsTextField.isSelectable = true
        detailsTextField.dataDetectorTypes = [.all]
        detailsTextField.isScrollEnabled = false

        var phoneArr: [String] = []
        contacts?.forEach {
            let phone = PhoneNumberFormatter.format($0.phone)
            if $0.name.isEmpty {
                phoneArr.append(phone)
            } else {
                phoneArr.append("\($0.name) \(phone)")
            }
        }
        let contactStr = phoneArr.joined(separator: ", ")

        if  !contactStr.isEmpty {
            contactsTextView.text = contactStr
            phonesConstraint.isActive = false
        } else {
            phoneCaptionLabel.text = ""
            phonesConstraint.isActive = true
        }

        let details = details ?? ""
        if !details.isEmpty {
            detailsTextField.text = details
            detailsConstraint.isActive = false
        } else {
            detailsTextField.text = ""
            detailsConstraint.isActive = true
        }
        contactsTextView.sizeToFit()
    }

    var privacyAndTermsAttrStr: NSAttributedString {
        let attrStr = NSMutableAttributedString(string: "Some long attribute string")
        return attrStr
    }
}
