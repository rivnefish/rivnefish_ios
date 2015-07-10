//
//  ViewController.swift
//  RivneFish
//
//  Created by akyryl on 09/04/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    var dataSource = DataSource()

    var markersAnnotations = [MarkerAnnotation]()

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

            // add markers to map
            for marker in markers as! [Marker] {
                self.markersAnnotations.append(MarkerAnnotation(marker: marker))
            }
            self.mapView.addAnnotations(self.markersAnnotations)
        })
    }

    /*func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }

        let reuseId = "test"

        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.image = UIImage(named:"xaxas")
            anView.canShowCallout = true
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView.annotation = annotation
        }
        
        return anView
    }

    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {

    }

    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {

    }

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {

    }

    func zoomIn(sender: AnyObject) {
        // TODO:
    }*/
}
