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

    // With apple maps it is possible to use FBAnnotationClustering

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var mapTypeButton: UIButton!

    let locationManager = CLLocationManager()
    var clusterManager: GClusterManager!

    fileprivate var markerDetailsController: PlaceDetailsController?
    fileprivate var currentPlace: Place?

    let settings = Settings(defaults: UserDefaults.standard)

    var allAnnotationsMapView: MKMapView! = MKMapView(frame: CGRect.zero)

    var dataSource = DataSource()
    var markersAnnotations = [MarkerAnnotation]()
    
    var gmMarkers = [GMarker]()
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

        initClusterManager()
        self.googleMapView.delegate = self
        self.updateData()
        
        if let width = UIImage(named: "m1")?.size.width {
            singleMarkerImageWidth = width
        }

        googleMapView.mapType = settings.currentMapType.gmType
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
            if let location = defaultLocation {
                googleMapView.animate(to: GMSCameraPosition(target: location.coordinate, zoom: 10, bearing: 0, viewingAngle: 0))
                locationManager.stopUpdatingLocation()
            }
        }
    }

    // MARK: Common methods
    
    func countriesReceived(_ countries: NSArray) {
        print(countries)
    }
    
    @IBAction func mapTypeChanged() {
        var newMapType: MapType
        switch settings.currentMapType {
        case .normal:
            newMapType = .hyblid
        default:
            newMapType = .normal
            break
        }
        settings.currentMapType = newMapType
        googleMapView.mapType = newMapType.gmType
        updateMapTypeButtonIcon()
    }

    private func updateMapTypeButtonIcon() {
        let imageName: String
        switch settings.currentMapType {
        case .normal:
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
                self.addMarkersToGoogleMap(places)
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
        populateDetailsControllerWithData()

        if let controller = markerDetailsController {
            self.navigationController?.pushViewController(controller, animated: true)
            let backButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
        }
    }

    fileprivate func populateDetailsControllerWithData() {
        if let controller = markerDetailsController {
            controller.dataSource = dataSource
            controller.currentLocation = currentLocation

            populateDetailsControllerWithFish()
            populateDetailsControllerWithPlace()
        }
    }

    fileprivate func populateDetailsControllerWithFish() {
        if let controller = markerDetailsController {
            if let fish = allFish {
                controller.allFish = fish
            }
        }
    }

    fileprivate func populateDetailsControllerWithPlace() {
        if let controller = markerDetailsController {
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
                    calloutView.setup()
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
}
