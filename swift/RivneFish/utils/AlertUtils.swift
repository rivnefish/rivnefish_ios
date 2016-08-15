//
//  AlertExtension.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 11/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class AlertUtils {
    static func okeyAlertWith(title title: String, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let ok = NSLocalizedString("Гаразд", comment: "OK")
        let okAction = UIAlertAction(title: ok, style: .Default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}
