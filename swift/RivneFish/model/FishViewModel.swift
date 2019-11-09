//
//  FishViewModel.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 24/10/2016.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import Foundation

import UIKit

class FishViewModel {
    let name: String
    let amount: Int
    let image: UIImage?
    let url: String?

    init?(name: String?, amount: Int?, url: String?, image: UIImage?) {
        if name == nil && url == nil && image == nil {
            return nil
        }

        self.name = name ?? ""
        self.amount = amount ?? 0
        self.image = image
        self.url = url
    }
}
