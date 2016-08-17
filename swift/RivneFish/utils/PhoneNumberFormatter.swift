//
//  PhoneNumberFormatter.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 17/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class PhoneNumberFormatter {
    static func format(tel: String) -> String {
        var s = tel
        if s.characters.first != "+" {
            s.insert("+", atIndex: s.characters.startIndex)
        }
        if s.characters.count >= 13 {
            return String(format: "%@ (%@) %@ %@ %@", s.substringToIndex(s.startIndex.advancedBy(4)),
                          s.substringWithRange(s.startIndex.advancedBy(4) ... s.startIndex.advancedBy(5)),
                          s.substringWithRange(s.startIndex.advancedBy(6) ... s.startIndex.advancedBy(8)),
                          s.substringWithRange(s.startIndex.advancedBy(9) ... s.startIndex.advancedBy(10)),
                          s.substringWithRange(s.startIndex.advancedBy(11) ... s.startIndex.advancedBy(12))
            )
        }
        return tel
    }
}
