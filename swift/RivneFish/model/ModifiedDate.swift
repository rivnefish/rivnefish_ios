//
//  ModifiedDate.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 28/02/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

let kLastChangesKey = "lastchanges"

class ModifiedDate {

    var number: NSNumber?

    init(dict: NSDictionary)
    {
        number = dict[kLastChangesKey] as? NSNumber
    }
}
