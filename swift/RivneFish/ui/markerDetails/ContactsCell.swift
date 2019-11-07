//
//  ContactsCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class ContactsCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var phoneCaptionLabel: UILabel!
    @IBOutlet weak var phoneCaptionVConstraint: UILabel!

    @IBOutlet weak var detailsConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsLabel: UILabel!

    var phoneNumber: String?

    func setup(withPhone phone: String?, details: String?) {
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = [.all]
        textView.isScrollEnabled = false
        textView.text = "\(PhoneNumberFormatter.format(phone!)), \(PhoneNumberFormatter.format(phone!))"

        let phone = phone ?? ""
        if  !phone.isEmpty {
            phoneNumber = phone
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
    }

    var privacyAndTermsAttrStr: NSAttributedString {
        let attrStr = NSMutableAttributedString(string: "Some long attribute string")
        return attrStr
    }
}
