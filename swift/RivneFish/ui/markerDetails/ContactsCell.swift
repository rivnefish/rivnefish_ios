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

    var phoneNumber: String?

    @IBAction func phonePressed(_ sender: UIButton) {
        if let phone = phoneNumber,
            let url = URL(string: "tel://\(phone)") {

            let application:UIApplication = UIApplication.shared
            if application.canOpenURL(url) {
                application.openURL(url)
            }
        }
    }

    func setup(withPhone phone: String?, details: String?) {
        let phone = phone ?? ""
        if  !phone.isEmpty {
            phoneNumber = phone
            phoneButton.setTitle(PhoneNumberFormatter.format(phone), for: UIControlState())
        } else {
            phoneCaptionLabel.text = ""
            phoneVConstraint.constant = 0
            phoneButton.setTitle("", for: UIControlState())
            phoneHeightConstraint.constant = 0
            phoneVConstraint.constant = 0
        }
        let details = details ?? ""
        if !details.isEmpty {
            detailsLabel.text = details
        } else {
            detailsLabel.text = ""
            detailsConstraint.constant = 0
        }
    }
}
