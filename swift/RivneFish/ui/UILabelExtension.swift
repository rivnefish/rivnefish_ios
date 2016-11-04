//
//  UILabelExtension.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 30/10/2016.
//  Copyright © 2016 rivnefish. All rights reserved.
//

extension UILabel {
    // TODO: Do not use it for now, might crash if html too big or contains video
    func setHtml(text: String, removingTextColor: Bool = false) {
        if !text.isEmpty,
            let attrData = text.data(using: String.Encoding.unicode, allowLossyConversion: true),
            let attributedStr = try? NSMutableAttributedString(data: attrData,
                                                               options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                               documentAttributes: nil) {
            let range = NSRange(location: 0, length: attributedStr.length)
            attributedStr.addAttribute(NSFontAttributeName,
                                       value: UIFont.systemFont(ofSize: self.font.pointSize),
                                       range: range)
            if removingTextColor {
                attributedStr.addAttribute(NSForegroundColorAttributeName,
                                           value: self.textColor,
                                           range: range)
            }
            self.attributedText = attributedStr
        }
    }
}
