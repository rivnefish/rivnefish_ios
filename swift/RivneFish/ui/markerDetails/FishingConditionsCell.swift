//
//  FishingConditionsCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class FishingConditionsCell: UITableViewCell {
    @IBOutlet weak var mainInfoLabel: UILabel!
    @IBOutlet weak var mainInfoVConstraint: NSLayoutConstraint!

    @IBOutlet weak var paymentCaptionLabel: UILabel!
    @IBOutlet weak var paymentCaptionVConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentVConstraint: NSLayoutConstraint!

    @IBOutlet weak var boatUsageCaptionLabel: UILabel!
    @IBOutlet weak var boatUsageCaptionVConstraint: NSLayoutConstraint!
    @IBOutlet weak var boatUsageLabel: UILabel!
    @IBOutlet weak var boatVConstraint: NSLayoutConstraint!

    @IBOutlet weak var fishingTimeCaptionLabel: UILabel!
    @IBOutlet weak var fishingTimeCaptionVConstraint: NSLayoutConstraint!
    @IBOutlet weak var fishingVConstraint: NSLayoutConstraint!
    @IBOutlet weak var fishingTimeLabel: UILabel!

    func setup(withMainInfo info: String?, payment: String?, boatUsage: String?, fishingTime: String?) {

        let info = info ?? ""
        if !info.isEmpty {
            mainInfoLabel.text = info
        } else {
            mainInfoLabel.text = ""
            mainInfoVConstraint.constant = 0
        }
        let payment = payment ?? ""
        if !payment.isEmpty {
            paymentLabel.text = payment
        } else {
            paymentCaptionLabel.text = ""
            paymentLabel.text = ""
            paymentCaptionVConstraint.constant = 0
            paymentVConstraint.constant = 0
        }

        let usage = boatUsage ?? ""
        if !usage.isEmpty {
            boatUsageLabel.text = usage
        } else {
            boatUsageCaptionLabel.text = ""
            boatUsageLabel.text = ""
            boatUsageCaptionVConstraint.constant = 0
            boatVConstraint.constant = 0
        }

        let time = fishingTime ?? ""
        if !time.isEmpty {
            fishingTimeLabel.text = time
        } else {
            fishingTimeCaptionLabel.text = ""
            fishingTimeLabel.text = ""
            fishingTimeCaptionVConstraint.constant = 0
            fishingVConstraint.constant = 0
        }
    }
}
