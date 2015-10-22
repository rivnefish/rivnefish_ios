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
        print(countries)
    }

    @IBAction func mapTypeChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = MKMapType.Standard
        case 1:
            self.mapView.mapType = MKMapType.Hybrid
        case 2:
            self.mapView.mapType = MKMapType.Satellite
        default:
            self.mapView.mapType = MKMapType.Standard
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateData() {
        dataSource.coutries({ (countries: NSArray) in
            print(countries)
        })

        dataSource.allAvailableMarkers({ (markers: NSArray) in

            // add markers to map
            for marker in markers as! [Marker] {
                self.markersAnnotations.append(MarkerAnnotation(marker: marker))
            }
            // TODO: add all annotatios to main map, just for testing, will be removed
            // self.mapView.addAnnotations(self.markersAnnotations)

            // TODO: my way
            // self.showAnnotations();

            // TODO: apple way clustering
            self.allAnnotationsMapView.addAnnotations(self.markersAnnotations)
            
            dispatch_async(dispatch_get_main_queue(),{
                // TODO: apple way clustering
                self.updateVisibleAnnotations()
                self.updateAll()
            })
        })
    }

    func showAnnotations() {

        // remove all annotations
        for annotation in self.markersAnnotations {
            self.mapView.removeAnnotation(annotation)
        }

        // add new
        var proceededAnnotations: Array<MarkerAnnotation> = Array()

        for var i = 0; i < self.markersAnnotations.count; ++i {
            // Take marker if it is not proceeded yet
            let annotation: MarkerAnnotation = self.markersAnnotations[i]
            if !proceededAnnotations.contains(annotation) {
                proceededAnnotations.append(annotation)
                // clear child annotations
                annotation.containedAnnotations = Array()

                // Loop all annotations and find closest to took annotation
                for var j = i + 1; j < self.markersAnnotations.count; ++j {
                    // Check if annotation is not proceeded
                    let childAnnotation = self.markersAnnotations[j]
                    if !proceededAnnotations.contains(childAnnotation) {

                        // Check how childAnnotation is close it to annotation
                        // And add it as child or skip

                        let p1 = self.mapView.convertCoordinate(annotation.coordinate, toPointToView: self.mapView)
                        let p2 = self.mapView.convertCoordinate(childAnnotation.coordinate, toPointToView: self.mapView)
                        let xDist = (p2.x - p1.x);
                        let yDist = (p2.y - p1.y);
                        let distance = sqrt((xDist * xDist) + (yDist * yDist));

                        if distance < 40 {
                            annotation.containedAnnotations!.append(childAnnotation)
                            proceededAnnotations.append(childAnnotation)
                        }
                    }
                }
                self.mapView.addAnnotation(annotation)
            }
        }
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
        let visibleMapRect: MKMapRect = self.mapView.visibleMapRect
        let adjustedVisibleMapRect: MKMapRect = MKMapRectInset(visibleMapRect, -marginFactor * visibleMapRect.size.width, -marginFactor * visibleMapRect.size.height)

        // determine how wide each bucket will be, as a MKMapRect square
        let leftCoordinate: CLLocationCoordinate2D = self.mapView.convertPoint(CGPointZero, toCoordinateFromView: self.view);
        let rightCoordinate: CLLocationCoordinate2D = self.mapView.convertPoint(CGPointMake(CGFloat(bucketSize), 0.0), toCoordinateFromView: self.view);
        let gridSize = MKMapPointForCoordinate(rightCoordinate).x - MKMapPointForCoordinate(leftCoordinate).x;
        var gridMapRect: MKMapRect = MKMapRectMake(0, 0, gridSize, gridSize);

        // condense annotations, with a padding of two squares, around the visibleMapRect
        let startX = floor(MKMapRectGetMinX(adjustedVisibleMapRect) / gridSize) * gridSize;
        let startY = floor(MKMapRectGetMinY(adjustedVisibleMapRect) / gridSize) * gridSize;
        let endX = floor(MKMapRectGetMaxX(adjustedVisibleMapRect) / gridSize) * gridSize;
        let endY = floor(MKMapRectGetMaxY(adjustedVisibleMapRect) / gridSize) * gridSize;

        // for each square in our grid, pick one annotation to show
        gridMapRect.origin.y = startY;
        while MKMapRectGetMinY(gridMapRect) <= endY {
            gridMapRect.origin.x = startX;

            while (MKMapRectGetMinX(gridMapRect) <= endX) {

                if let objects: Set<NSObject>? = allAnnotationsMapView.annotationsInMapRect(gridMapRect) {
                    let allAnnotationsInBucket: NSSet = self.allAnnotationsMapView.annotationsInMapRect(gridMapRect);
                    let visibleAnnotationsInBucket: NSSet = self.mapView.annotationsInMapRect(gridMapRect);

                    // we only care about PhotoAnnotations
                    let filteredAnnotationsInBucketImmutable: NSSet =
                    allAnnotationsInBucket.objectsPassingTest({ (obj: AnyObject, stop: UnsafeMutablePointer<ObjCBool>) -> Bool in
                        return obj.isKindOfClass(MarkerAnnotation)
                    })
                    let filteredAnnotationsInBucket: NSMutableSet = filteredAnnotationsInBucketImmutable.mutableCopy() as! NSMutableSet

                    if  filteredAnnotationsInBucket.count > 0 {
                        let annotationForGrid: MarkerAnnotation = self.annotationInGrid(gridMapRect, annotations: filteredAnnotationsInBucket)

                        filteredAnnotationsInBucket.removeObject(annotationForGrid)

                        // give the annotationForGrid a reference to all the annotations it will represent
                        annotationForGrid.containedAnnotations = filteredAnnotationsInBucket.allObjects as? Array<MarkerAnnotation>

                        self.mapView.addAnnotation(annotationForGrid);

                        for annotation in filteredAnnotationsInBucket.allObjects as! [MarkerAnnotation] {
                            // give all the other annotations a reference to the one which is representing them
                            annotation.clusterAnnotation = annotationForGrid;
                            annotation.containedAnnotations = nil;

                            // remove annotations which we've decided to cluster
                            if visibleAnnotationsInBucket.containsObject(annotation) {
                                let actualCoordinate: CLLocationCoordinate2D = annotation.coordinate

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
            }
            gridMapRect.origin.y += gridSize;
        }
    }

    func annotationInGrid(gridMapRect: MKMapRect, annotations: NSSet) -> MarkerAnnotation {
        let visibleAnnotationsInBucket: NSSet = self.mapView.annotationsInMapRect(gridMapRect);
        let annotationsForGridSet: NSSet = annotations.objectsPassingTest({ (obj: AnyObject, stop: UnsafeMutablePointer<ObjCBool>) -> Bool in
            let returnValue: Bool = visibleAnnotationsInBucket.containsObject(obj)
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
        let centerMapPoint: MKMapPoint = MKMapPointMake(MKMapRectGetMidX(gridMapRect), MKMapRectGetMidY(gridMapRect))


        let sortedAnnotations: NSArray = annotations.allObjects.sort {
            (obj1, obj2) in

            let annotation1: MKAnnotation = obj1 as! MKAnnotation
            let mapPoint1: MKMapPoint = MKMapPointForCoordinate(annotation1.coordinate)
            let annotation2: MKAnnotation = obj2 as! MKAnnotation
            let mapPoint2: MKMapPoint = MKMapPointForCoordinate(annotation2.coordinate)

            let distance1: CLLocationDistance = MKMetersBetweenMapPoints(mapPoint1, centerMapPoint)
            let distance2: CLLocationDistance = MKMetersBetweenMapPoints(mapPoint2, centerMapPoint)

            return distance1 > distance2
        }

        return sortedAnnotations[0] as! MarkerAnnotation;
    }

    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // apple way clustering
        self.updateVisibleAnnotations()
        updateAll()
        
        // TODO: my way
        // self.showAnnotations();
    }

    // MKMapViewDelegate

    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {

        for annotationView: MKAnnotationView in views {
            if !annotationView.annotation!.isKindOfClass(MarkerAnnotation) {
                continue
            }
            let annotation: MarkerAnnotation = annotationView.annotation as! MarkerAnnotation

            if annotation.clusterAnnotation != nil {
                // animate the annotation from it's old container's coordinate, to its actual coordinate
                let actualCoordinate: CLLocationCoordinate2D = annotation.coordinate
                let containerCoordinate: CLLocationCoordinate2D = annotation.clusterAnnotation!.coordinate
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

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView? = nil
        if (annotation is MarkerAnnotation) {
            let reuseId = "MarkerAnnotationViewId"
            view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            let markerAnnotation: MarkerAnnotation = annotation as! MarkerAnnotation
            if view == nil {
                let markerAnnotation: MarkerAnnotation = annotation as! MarkerAnnotation
                view = MarkerAnnotationView.instanceFromNib(markerAnnotation.containedItemsCount)
            } else {
                let markerAnnotationView: MarkerAnnotationView = view as! MarkerAnnotationView
                markerAnnotationView.annotation = markerAnnotation
                markerAnnotationView.itemsCount = markerAnnotation.containedItemsCount
                markerAnnotationView.updateImageAndText()
            }
            view?.canShowCallout = (markerAnnotation.containedItemsCount == 0)
        }
        return view
    }

    func updateAll() {
        for markerAnnotation: MarkerAnnotation in markersAnnotations as [MarkerAnnotation] {
            let annotView = mapView.viewForAnnotation(markerAnnotation);

            if annotView != nil {
                let markerAnnotationView: MarkerAnnotationView = annotView as! MarkerAnnotationView

                markerAnnotationView.annotation = markerAnnotation
                markerAnnotationView.itemsCount = markerAnnotation.containedItemsCount
                markerAnnotationView.updateImageAndText()
                markerAnnotationView.canShowCallout = (markerAnnotation.containedItemsCount == 0)
            }
        }
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation: MarkerAnnotation = view.annotation as! MarkerAnnotation
        let spotViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SpotViewController") as! SpotViewController
        if let marker: Marker = annotation.marker
        {
            spotViewController.marker = marker
            dataSource.fishForMarkerID(marker.markerID.integerValue, fishReceived: { (fish: NSArray) in
                spotViewController.fishArray = fish as? Array<Fish>
            })
        }
        self.navigationController?.pushViewController(spotViewController, animated: true)
        let backButton: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Мапа", comment: "map"), style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
}
