//
//  LinkCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 08/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class LinkCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    var urlString: String?
    
    @IBAction func buttonCliccked(_ sender: AnyObject) {
        if let urlStr = urlString,
            let url = URL(string: urlStr) {
            UIApplication.shared.openURL(url)
        }
    }

    func setup(withLinkText linkText: String, urlString: String) {
        label.text = linkText
        self.urlString = urlString
    }
}
