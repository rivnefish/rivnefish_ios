//
//  ContactsCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var phoneCaptionLabel: UILabel!
    @IBOutlet weak var phoneCaptionVConstraint: UILabel!

    @IBOutlet weak var detailsConstraint: NSLayoutConstraint!
    @IBOutlet weak var phonesConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsLabel: UILabel!

    var phoneNumber: String?

    func setup(contacts: [PlaceContact]?, details: String?) {
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = [.all]
        textView.isScrollEnabled = false
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
            textView.text = contactStr
        } else {
            phoneCaptionLabel.text = ""
        }

        let details = details ?? ""
        if !details.isEmpty {
            detailsLabel.text = details
        } else {
            detailsLabel.text = ""
            detailsConstraint.constant = 0
        }
        textView.sizeToFit()
    }

    var privacyAndTermsAttrStr: NSAttributedString {
        let attrStr = NSMutableAttributedString(string: "Some long attribute string")
        return attrStr
    }
}
