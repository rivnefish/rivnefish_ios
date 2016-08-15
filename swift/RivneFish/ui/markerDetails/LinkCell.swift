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
    
    @IBAction func buttonCliccked(sender: AnyObject) {
        if let urlStr = urlString,
            let url = NSURL(string: urlStr) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    func setup(withLinkText linkText: String, urlString: String) {
        label.text = linkText
        self.urlString = urlString
    }
}
