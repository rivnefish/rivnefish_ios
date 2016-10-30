//
//  ViewController.swift
//  RivneFish
//
//  Created by akyryl on 09/04/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit
import MapKit
import SystemConfiguration

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var googleMapView: GMSMapView!

    let locationManager = CLLocationManager()
    var clusterManager: GClusterManager!

    fileprivate var markerDetailsController: PlaceDetailsController?
    fileprivate var currentPlace: Place?

    var allAnnotationsMapView: MKMapView! = MKMapView(frame: CGRect.zero)

    var dataSource = DataSource()
    var markersAnnotations = [MarkerAnnotation]()
    
    var gmMarkers = [GMarker]()
    var singleMarkerImageWidth: CGFloat = CGFloat(0.0)

    var currentLocation: CLLocation? = nil

    var allFish: Array<Fish>?
    
    // will be init in viewDidLoad
    var reach: Reach!
    
    var defaultLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.initRechability()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        initClusterManager()
        self.googleMapView.delegate = self
        self.updateData()
        
        if let width = UIImage(named: "m1")?.size.width {
            singleMarkerImageWidth = width
        }
        
        // TODO: Save it not here
        defaultLocation = CLLocation(latitude: 50.619780, longitude: 26.251471)
    }

    func initRechability() {
        self.reach = Reach.reachabilityForInternetConnection()

        // Set the blocks
        self.reach!.reachableBlock = {
            (reach: Reach?) -> Void in
            
            // keep in mind this is called on a background thread
            // and if you are updating the UI it needs to happen
            // on the main thread, like this:
            DispatchQueue.main.async {
                // Simply update data when connection appear
                self.updateData()
                self.populateMarkerDetailsControllerWithData()
            }
        }

        self.reach!.unreachableBlock = {
            (reach: Reach?) -> Void in
            DispatchQueue.main.async {
                // Show message error when connection is lost
                self.showConnectionErrorAlert()
            }
        }
        self.reach!.startNotifier()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            googleMapView.isMyLocationEnabled = true
            googleMapView.settings.myLocationButton = true
        }
        else
        {
            googleMapView.animate(to: GMSCameraPosition(target: defaultLocation.coordinate, zoom: 10, bearing: 0, viewingAngle: 0))
            locationManager.stopUpdatingLocation()
        }
    }

    // MARK: Common methods
    
    func countriesReceived(_ countries: NSArray) {
        print(countries)
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        
        /*switch sender.selectedSegmentIndex {
        case 0:
        self.mapView.mapType = MKMapType.Standard
        case 1:
        self.mapView.mapType = MKMapType.Hybrid
        case 2:
        self.mapView.mapType = MKMapType.Satellite
        default:
        self.mapView.mapType = MKMapType.Standard
        }*/
    }
    
    func updateData() {
        loadPlaces()
        loadFish()
    }

    func loadPlaces() {
        dataSource.places(self.reach, completionHandler: { (placesArr: Array<Place>?) in
            // self.addMarkersToAppleMaps(markers)

            guard let places = placesArr else { return }

            if  places.count == 0 {
                self.showConnectionErrorAlert()
            } else {
                self.addMarkersToGoogleMap(places)
            }
        })
    }

    func loadFish() {
        dataSource.allFish(rechability: self.reach, completionHandler: { (fishArr: Array<Fish>?) in
            guard let fish = fishArr else { return }

            self.allFish = fish
        })
    }

    // TODO: move to some ui utils class
    func showConnectionErrorAlert() {
        let title = NSLocalizedString("Помилка Підключення", comment: "ConnectionError")
        let message = NSLocalizedString("Немає підключення або відсутній звя'зок з сервером", comment: "You are offline or there is no connection with server")
        let alert = AlertUtils.okeyAlertWith(title: title, message: message)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: GOOGLE MAPS

    func initClusterManager() {
        let renderer = GDefaultClusterRenderer(mapView: self.googleMapView)
        self.clusterManager = GClusterManager(mapView: self.googleMapView, algorithm: NonHierarchicalDistanceBasedAlgorithm(), renderer: renderer)
        
        // Do not do this as GClustering expects.
        // self.googleMapView.delegate = clusterManager
        // We needs this controller to be google maps delegate, so just needed method of cluster manager will be called
        // it is func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!)
    }

    func addGMMarkers() {
        self.googleMapView.clear()
        clusterManager.removeItems()

        for markerAnnotation: GMarker in self.gmMarkers {
            // markerAnnotation.map = self.googleMapView - do not do that, clusterManager will do everhthing
            clusterManager.addItem(markerAnnotation)
        }
        clusterManager.cluster()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location: CLLocation = locations.first {
            currentLocation = location
            googleMapView.animate(to: GMSCameraPosition(target: location.coordinate, zoom: 11, bearing: 0, viewingAngle: 0))
            locationManager.stopUpdatingLocation()
        }
    }

    func addMarkersToGoogleMap(_ markers: Array<Place>) {
        // remove old
        self.gmMarkers.removeAll()

        // add new
        for markerModel in markers {
            let markerAnnotation = GMarker(placeModel: markerModel)
            self.gmMarkers.append(markerAnnotation)
        }
        self.addGMMarkers()
    }

    func goToMarkerDetailsView() {
        markerDetailsController = self.storyboard!.instantiateViewController(withIdentifier: "MarkerDetailsController") as? PlaceDetailsController
        populateMarkerDetailsControllerWithData()

        if let controller = markerDetailsController {
            self.navigationController?.pushViewController(controller, animated: true)
            let backButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
        }
    }

    fileprivate func populateMarkerDetailsControllerWithData() {
        if let controller = markerDetailsController {
            controller.dataSource = dataSource
            controller.currentLocation = currentLocation
            /*if let markerModel = currentPlace {
                controller.marker = markerModel
                dataSource.fishForMarker(self.reach, marker: markerModel, completionHandler: { (fish: NSArray) in
                    controller.fishArray = fish as? Array<Fish>
                })
            }*/

            if let fish = allFish {
                controller.allFish = fish
            }
            if let place = currentPlace {
                controller.place = place
            }
        }
    }

    // MARK: Google Maps delegate methods
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.clusterManager.mapView(self.googleMapView, idleAt: position)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        if isSinglePointMarker(marker) {
            if let markerModel: Place = marker.userData as? Place {
                if let calloutView: MarkerCalloutView = UINib(nibName: "MarkerCalloutView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? MarkerCalloutView {
                    calloutView.nameLabel.text = markerModel.name
                    calloutView.updateWidth()
                    return calloutView
                }
            }
        } else {
            googleMapView.animate(to: GMSCameraPosition(target: marker.position, zoom: googleMapView.camera.zoom + 1, bearing: 0, viewingAngle: 0))
        }
        return nil
    }

    // TODO: to not touching GClustering library, there is temporary solution to check if it is single marker
    func isSinglePointMarker(_ marker: GMSMarker) -> Bool {
        var returnVal = false
        if marker.icon?.size.width == singleMarkerImageWidth {
            returnVal = true
        }
        return returnVal
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let markerModel: Place = marker.userData as? Place {
            self.currentPlace = markerModel
            self.goToMarkerDetailsView()
        }
    }

    // MARK: - APPLE MAPS
    func addMarkersToAppleMaps(_ places: NSArray) {
        for place in places as! [Place] {
            self.markersAnnotations.append(MarkerAnnotation(place: place))
        }
        
        // TODO: add all annotatios to main map, just for testing, will be removed
        // self.mapView.addAnnotations(self.markersAnnotations)
        
        // TODO: my clustering
        // self.showAnnotations();
        
        // TODO: apple way clustering
        self.allAnnotationsMapView.addAnnotations(self.markersAnnotations)
        
        DispatchQueue.main.async(execute: {
            
            for place in places as! [Place] {
                self.markersAnnotations.append(MarkerAnnotation(place: place))
            }
            
            // TODO: apple way clustering
            // self.updateAll()
        })
    }
    
    func showAnnotations() {
        // remove all annotations
        for annotation in self.markersAnnotations {
            self.mapView.removeAnnotation(annotation)
        }

        // add new
        var proceededAnnotations: Array<MarkerAnnotation> = Array()

        for i in 0 ..< self.markersAnnotations.count {
            // Take marker if it is not proceeded yet
            let annotation: MarkerAnnotation = self.markersAnnotations[i]
            if !proceededAnnotations.contains(annotation) {
                proceededAnnotations.append(annotation)
                // clear child annotations
                annotation.containedAnnotations = Array()

                // Loop all annotations and find closest to took annotation
                for j in i + 1 ..< self.markersAnnotations.count {
                    // Check if annotation is not proceeded
                    let childAnnotation = self.markersAnnotations[j]
                    if !proceededAnnotations.contains(childAnnotation) {

                        // Check how childAnnotation is close it to annotation
                        // And add it as child or skip

                        let p1 = self.mapView.convert(annotation.coordinate, toPointTo: self.mapView)
                        let p2 = self.mapView.convert(childAnnotation.coordinate, toPointTo: self.mapView)
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


    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // apple way clustering
        updateAll()
        
        // TODO: my way
        // self.showAnnotations();
    }

    // MARK: MKMapViewDelegate

    private func mapView(_ mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {

        for annotationView: MKAnnotationView in views {
            if let annotation: MarkerAnnotation = annotationView.annotation as? MarkerAnnotation {
                if annotation.clusterAnnotation != nil {
                    // animate the annotation from it's old container's coordinate, to its actual coordinate
                    let actualCoordinate: CLLocationCoordinate2D = annotation.coordinate
                    let containerCoordinate: CLLocationCoordinate2D = annotation.clusterAnnotation!.coordinate
                    // since it's displayed on the map, it is no longer contained by another annotation,
                    // (We couldn't reset this in -updateVisibleAnnotations because we needed the reference to it here
                    // to get the containerCoordinate)
                    annotation.clusterAnnotation = nil
                    annotation.coordinate = containerCoordinate

                    UIView.animate(withDuration: 0.3, animations: {
                        annotation.coordinate = actualCoordinate
                    })
                }
            }
        }
    }

    private func mapView(_ mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView? = nil
        if (annotation is MarkerAnnotation) {
            let reuseId = "MarkerAnnotationViewId"
            view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
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
            let annotView = mapView.view(for: markerAnnotation);

            if annotView != nil {
                let markerAnnotationView: MarkerAnnotationView = annotView as! MarkerAnnotationView

                markerAnnotationView.annotation = markerAnnotation
                markerAnnotationView.itemsCount = markerAnnotation.containedItemsCount
                markerAnnotationView.updateImageAndText()
                markerAnnotationView.canShowCallout = (markerAnnotation.containedItemsCount == 0)
            }
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation: MarkerAnnotation? = view.annotation as? MarkerAnnotation
        if let place: Place = annotation?.place
        {
            self.currentPlace = place
            self.goToMarkerDetailsView()
        }
    }
}
