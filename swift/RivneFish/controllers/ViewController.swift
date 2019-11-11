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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    fileprivate static let kPlusZoomFactor = 0.5

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeButton: UIButton!

    var annotations: [PlaceMarker] = []

    let locationManager = CLLocationManager()

    fileprivate var markerDetailsController: PlaceDetailsController?
    fileprivate var currentPlace: Place?

    let settings = Settings(defaults: UserDefaults.standard)

    var allAnnotationsMapView: MKMapView! = MKMapView(frame: CGRect.zero)

    var dataSource = DataSource()
    var singleMarkerImageWidth: CGFloat = CGFloat(0.0)

    var currentLocation: CLLocation? = nil

    var allFish: Array<Fish>?
    
    // will be init in viewDidLoad
    var reach: Reach!
    
    var defaultLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initRechability()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }

        self.updateData()
        
        if let width = UIImage(named: "marker")?.size.width {
            singleMarkerImageWidth = width
        }

        mapView.mapType = settings.currentMapType
        updateMapTypeButtonIcon()
    }

    // MARK: Reachability

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
                self.populateDetailsControllerWithData()
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

    // MARK: Common methods
    
    func countriesReceived(_ countries: NSArray) {
        print(countries)
    }
    
    @IBAction func mapTypeChanged() {
        var newMapType: MKMapType
        switch settings.currentMapType {
        case .standard:
            newMapType = .hybrid
        default:
            newMapType = .standard
            break
        }
        settings.currentMapType = newMapType
        mapView.mapType = newMapType
        updateMapTypeButtonIcon()
    }

    private func updateMapTypeButtonIcon() {
        let imageName: String
        switch settings.currentMapType {
        case .standard:
            imageName = "satellite"
        default:
            imageName = "earth"
            break
        }
        mapTypeButton.setImage(UIImage(named: imageName), for: .normal)
    }

    func updateData() {
        loadPlaces()
        loadFish()
    }

    func loadPlaces() {
        dataSource.places(self.reach, completionHandler: { (placesArr: Array<Place>?) in
            guard let places = placesArr else { return }

            if  places.count == 0 {
                self.showConnectionErrorAlert()
            } else {
                self.addMarkersToAppleMap(places)
            }
        })
    }

    func loadFish() {
        dataSource.allFish(rechability: self.reach, completionHandler: { (fishArr: Array<Fish>?) in
            guard let fish = fishArr else { return }

            self.allFish = fish
            self.populateDetailsControllerWithFish()
        })
    }

    func showConnectionErrorAlert() {
        let alert = AlertUtils.connectionErrorAlert()
        self.present(alert, animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location: CLLocation = locations.first {
            currentLocation = location

            // let location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span = MKCoordinateSpanMake(0.5, 0.5)
            let region = MKCoordinateRegion (center: location.coordinate, span: span)

            mapView.setRegion(region, animated: true)

            // googleMapView.animate(to: GMSCameraPosition(target: location.coordinate, zoom: 11, bearing: 0, viewingAngle: 0))
            locationManager.stopUpdatingLocation()
        }
    }

    func goToMarkerDetailsView() {
        markerDetailsController = self.storyboard!.instantiateViewController(withIdentifier: "MarkerDetailsController") as? PlaceDetailsController
        populateDetailsControllerWithData()

        if let controller = markerDetailsController {
            self.navigationController?.pushViewController(controller, animated: true)
            let backButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
        }
    }

    func populateDetailsControllerWithData() {
        if let controller = markerDetailsController {
            controller.dataSource = dataSource
            controller.currentLocation = currentLocation

            populateDetailsControllerWithFish()
            populateDetailsControllerWithPlace()
        }
    }

    func populateDetailsControllerWithFish() {
        if let controller = markerDetailsController {
            if let fish = allFish {
                controller.allFish = fish
            }
        }
    }

    func populateDetailsControllerWithPlace() {
        if let controller = markerDetailsController {
            if let place = currentPlace {
                controller.place = place
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? MKClusterAnnotation {
            return annotationViewForClusterMarker(annotation: annotation)
        } else if let annotation = annotation as? PlaceMarker {
            return annotationViewSingleMarker(annotation: annotation)
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let _ = view.annotation as? MKClusterAnnotation else { return }

        mapView.changeZoomByFactor(ViewController.kPlusZoomFactor)
    }

    func annotationViewForClusterMarker(annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "cluster"
        var view: ClusterAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? ClusterAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = ClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }

    func annotationViewSingleMarker(annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "marker"
        var view: PlaceMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? PlaceMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = PlaceMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            if let img = UIImage.init(named: "marker") {
                view.centerOffset = CGPoint(x: 0, y: -img.size.height / 2)
            }

            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }

    func addMarkersToAppleMap(_ markers: Array<Place>) {
        mapView.removeAnnotations(annotations)

        annotations.removeAll()
        for markerModel in markers {
            let markerAnnotation = PlaceMarker(place: markerModel)
            annotations.append(markerAnnotation)
        }
        mapView.addAnnotations(annotations)
    }

    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
        guard let marker = view.annotation as? PlaceMarker else { return }

        self.currentPlace = marker.place
        self.goToMarkerDetailsView()
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard view.isKind(of: PlaceMarkerAnnotationView.self) else { return }

        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
}

extension MKMapView {
    var zoomLevel: Int {
        let zero = self.convert(CGPoint.zero, toCoordinateFrom: self)
        let oneOne = self.convert(CGPoint(x: 1.0, y: 1.0), toCoordinateFrom: self)
        let diff = zero.latitude > oneOne.latitude ? zero.latitude - oneOne.latitude : oneOne.latitude - zero.latitude
        let delta = round(-1 * log2(diff) - 0.5)

        return Int(delta)
    }

    func changeZoomByFactor(_ zoomFactor: Double) {
        changeZoomByFactor(zoomFactor, centerCoordinate: region.center)
    }

    func changeZoomByFactor(_ zoomFactor: Double, centerCoordinate: CLLocationCoordinate2D) {
        let latSpan = region.span.latitudeDelta * zoomFactor
        let lonSpan = region.span.longitudeDelta * zoomFactor
        let newRegion = MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan))
        if newRegion.isValid() {
            setRegion(newRegion, animated: true)
        }
    }
}

extension MKCoordinateRegion {
    func isValid() -> Bool {
        return span.latitudeDelta > 0.0 && span.latitudeDelta < 180.0 &&
        span.longitudeDelta > 0.0 && span.longitudeDelta < 180.0
    }
}
