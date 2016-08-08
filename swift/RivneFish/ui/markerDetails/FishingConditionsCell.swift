//
//  FishingConditionsCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class FishingConditionsCell: UITableViewCell {

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

    func setup(withPayment payment: String?, boatUsage: String?, fishingTime: String?) {

        if let payment = payment {
            paymentLabel.text = payment
        } else {
            paymentCaptionLabel.text = ""
            paymentLabel.text = ""
            paymentCaptionVConstraint.constant = 0
            paymentVConstraint.constant = 0
        }

        if let usage = boatUsage {
            boatUsageLabel.text = usage
        } else {
            boatUsageCaptionLabel.text = ""
            boatUsageLabel.text = ""
            boatUsageCaptionVConstraint.constant = 0
            boatVConstraint.constant = 0
        }

        if let time = fishingTime {
            fishingTimeLabel.text = time
        } else {
            fishingTimeCaptionLabel.text = ""
            fishingTimeLabel.text = ""
            fishingTimeCaptionVConstraint.constant = 0
            fishingVConstraint.constant = 0
        }
    }
}
