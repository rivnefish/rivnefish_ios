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
    var allAnnotationsMapView: MKMapView! = MKMapView(frame: CGRectZero)

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
            // TODO: add all annotatios to main map, just for testing, will be removed
            // self.mapView.addAnnotations(self.markersAnnotations)

            self.allAnnotationsMapView.addAnnotations(self.markersAnnotations)
            self.updateVisibleAnnotations()
        })
    }

    func updateVisibleAnnotations() {

        // This value to controls the number of off screen annotations are displayed.
        // A bigger number means more annotations, less chance of seeing annotation views pop in but decreased performance.
        // A smaller number means fewer annotations, more chance of seeing annotation views pop in but better performance.
        let marginFactor = 2.0

        // Adjust this roughly based on the dimensions of your annotations views.
        // Bigger numbers more aggressively coalesce annotations (fewer annotations displayed but better performance).
        // Numbers too small result in overlapping annotations views and too many annotations on screen.
        let bucketSize = 60.0

        // find all the annotations in the visible area + a wide margin to avoid popping annotation views in and out while panning the map.
        var visibleMapRect: MKMapRect = self.mapView.visibleMapRect
        var adjustedVisibleMapRect: MKMapRect = MKMapRectInset(visibleMapRect, -marginFactor * visibleMapRect.size.width, -marginFactor * visibleMapRect.size.height)

        // determine how wide each bucket will be, as a MKMapRect square
        var leftCoordinate: CLLocationCoordinate2D = self.mapView.convertPoint(CGPointZero, toCoordinateFromView: self.view);
        var rightCoordinate: CLLocationCoordinate2D = self.mapView.convertPoint(CGPointMake(CGFloat(bucketSize), 0.0), toCoordinateFromView: self.view);
        var gridSize = MKMapPointForCoordinate(rightCoordinate).x - MKMapPointForCoordinate(leftCoordinate).x;
        var gridMapRect: MKMapRect = MKMapRectMake(0, 0, gridSize, gridSize);

        // condense annotations, with a padding of two squares, around the visibleMapRect
        var startX = floor(MKMapRectGetMinX(adjustedVisibleMapRect) / gridSize) * gridSize;
        var startY = floor(MKMapRectGetMinY(adjustedVisibleMapRect) / gridSize) * gridSize;
        var endX = floor(MKMapRectGetMaxX(adjustedVisibleMapRect) / gridSize) * gridSize;
        var endY = floor(MKMapRectGetMaxY(adjustedVisibleMapRect) / gridSize) * gridSize;

        // for each square in our grid, pick one annotation to show
        gridMapRect.origin.y = startY;
        while MKMapRectGetMinY(gridMapRect) <= endY {
            gridMapRect.origin.x = startX;

            while (MKMapRectGetMinX(gridMapRect) <= endX) {

                if allAnnotationsMapView.annotationsInMapRect(gridMapRect) == nil {
                    gridMapRect.origin.x += gridSize;
                    continue
                }
                var allAnnotationsInBucket: NSSet = self.allAnnotationsMapView.annotationsInMapRect(gridMapRect);
                var visibleAnnotationsInBucket: NSSet = self.mapView.annotationsInMapRect(gridMapRect);

                // we only care about PhotoAnnotations
                var filteredAnnotationsInBucketImmutable: NSSet =
                allAnnotationsInBucket.objectsPassingTest({ (obj: AnyObject!, stop: UnsafeMutablePointer<ObjCBool>) -> Bool in
                        return obj.isKindOfClass(MarkerAnnotation)
                    })
                var filteredAnnotationsInBucket: NSMutableSet = filteredAnnotationsInBucketImmutable.mutableCopy() as! NSMutableSet

                if  filteredAnnotationsInBucket.count > 0 {
                    var annotationForGrid: MarkerAnnotation = self.annotationInGrid(gridMapRect, annotations: filteredAnnotationsInBucket)

                    filteredAnnotationsInBucket.removeObject(annotationForGrid)

                    // give the annotationForGrid a reference to all the annotations it will represent
                    annotationForGrid.containedAnnotations = filteredAnnotationsInBucket.allObjects

                    self.mapView.addAnnotation(annotationForGrid);

                    for annotation in filteredAnnotationsInBucket.allObjects as! [MarkerAnnotation] {
                        // give all the other annotations a reference to the one which is representing them
                        annotation.clusterAnnotation = annotationForGrid;
                        annotation.containedAnnotations = nil;

                        // remove annotations which we've decided to cluster
                        if visibleAnnotationsInBucket.containsObject(annotation) {
                            var actualCoordinate: CLLocationCoordinate2D = annotation.coordinate

                            //annotation.coordinate = CLLocationCoordinate2D()

                            UIView.animateWithDuration(0.3, animations: {
                                if let a = annotation.clusterAnnotation {
                                    annotation.coordinate = a.coordinate
                                }
                            }, completion: {
                                (value: Bool) in
                                annotation.coordinate = actualCoordinate
                                self.mapView.removeAnnotation(annotation)
                            })
                        }
                    }
                }

                gridMapRect.origin.x += gridSize;
            }
            gridMapRect.origin.y += gridSize;
        }
    }

    func annotationInGrid(gridMapRect: MKMapRect, annotations: NSSet) -> MarkerAnnotation {
        var visibleAnnotationsInBucket: NSSet = self.mapView.annotationsInMapRect(gridMapRect);
        var annotationsForGridSet: NSSet = annotations.objectsPassingTest({ (obj: AnyObject!, stop: UnsafeMutablePointer<ObjCBool>) -> Bool in
            var returnValue: Bool = visibleAnnotationsInBucket.containsObject(obj)
            if returnValue {
                stop.memory = true
            }
            return returnValue
        })

        if annotationsForGridSet.count != 0 {
            return annotationsForGridSet.anyObject() as! MarkerAnnotation
        }

        // otherwise, sort the annotations based on their distance from the center of the grid square,
        // then choose the one closest to the center to show
        var centerMapPoint: MKMapPoint = MKMapPointMake(MKMapRectGetMidX(gridMapRect), MKMapRectGetMidY(gridMapRect))


        var sortedAnnotations: NSArray = sorted(annotations.allObjects) {
            (obj1, obj2) in

            var annotation1: MKAnnotation = obj1 as! MKAnnotation
            var mapPoint1: MKMapPoint = MKMapPointForCoordinate(annotation1.coordinate)
            var annotation2: MKAnnotation = obj2 as! MKAnnotation
            var mapPoint2: MKMapPoint = MKMapPointForCoordinate(annotation2.coordinate)

            var distance1: CLLocationDistance = MKMetersBetweenMapPoints(mapPoint1, centerMapPoint)
            var distance2: CLLocationDistance = MKMetersBetweenMapPoints(mapPoint2, centerMapPoint)

            return distance1 > distance2
        }

        return sortedAnnotations[0] as! MarkerAnnotation;
    }

    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        self.updateVisibleAnnotations()
    }

    // MKMapViewDelegate

    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {

        for annotationView: MKAnnotationView in views as! [MKAnnotationView] {
            if !annotationView.annotation.isKindOfClass(MarkerAnnotation) {
                continue
            }
            var annotation: MarkerAnnotation = annotationView.annotation as! MarkerAnnotation

            if annotation.clusterAnnotation != nil {
                // animate the annotation from it's old container's coordinate, to its actual coordinate
                var actualCoordinate: CLLocationCoordinate2D = annotation.coordinate
                var containerCoordinate: CLLocationCoordinate2D = annotation.clusterAnnotation!.coordinate
                // since it's displayed on the map, it is no longer contained by another annotation,
                // (We couldn't reset this in -updateVisibleAnnotations because we needed the reference to it here
                // to get the containerCoordinate)
                annotation.clusterAnnotation = nil
                annotation.coordinate = containerCoordinate

                UIView.animateWithDuration(0.3, animations: {
                    annotation.coordinate = actualCoordinate
                })
            }
        }
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
