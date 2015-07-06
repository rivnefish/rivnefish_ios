//
//  ViewController.swift
//  RivneFish
//
//  Created by akyryl on 09/04/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataSource = DataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // let dataSource:DataSource = DataSource()
        // dataSource.coutries(countriesReceived)

        self.updateData()
    }

    func countriesReceived(countries: NSArray) {
        // println(NSString(data: data, encoding: NSUTF8StringEncoding))
        println(countries)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateData() {
        dataSource.coutries({ (countries: NSArray) in
            println(countries)
        })

        dataSource.markers({ (markers: NSArray) in
            println(markers)
        })
    }
}

