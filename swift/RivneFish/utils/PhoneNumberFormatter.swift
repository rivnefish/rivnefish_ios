//
//  PhoneNumberFormatter.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 17/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class PhoneNumberFormatter {
    static func format(_ tel: String) -> String {
        var s = tel
        if s.first != "+" {
            s.insert("+", at: s.startIndex)
        }
        if s.count >= 13 {
            return String(format: "%@ (%@) %@ %@ %@", s.substring(to: s.index(s.startIndex, offsetBy: 4)),
                          s.substring(with: s.index(s.startIndex, offsetBy: 4) ..< s.index(s.startIndex, offsetBy: 6)),
                          s.substring(with: s.index(s.startIndex, offsetBy: 6) ..< s.index(s.startIndex, offsetBy: 9)),
                          s.substring(with: s.index(s.startIndex, offsetBy: 9) ..< s.index(s.startIndex, offsetBy: 11)),
                          s.substring(with: s.index(s.startIndex, offsetBy: 11) ..< s.index(s.startIndex, offsetBy: 13))
            )
        }
        return tel
    }
}
