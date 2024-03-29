//
//  PlaceDetailsController.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import CoreLocation

class PlaceDetailsController: UIViewController {
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var loadingBlur: UIVisualEffectView!
    @IBOutlet weak var navigationButton: UIBarButtonItem!
    @IBOutlet weak var noDataLabel: UILabel! {
        didSet {
            noDataLabel.textColor = Constants.Colors.kMain
            noDataLabel.text = "Помилка з'єднання. Перевірте налаштування мережі або спробуйте пізніше."
        }
    }

    @IBOutlet weak var contentTable: UITableView! {
        didSet {
            cellsCreator = PlaceDetailsCellCreator(table: contentTable, selectPlaceImageHandler: goToPlacePhotosView)
            cellsCreator?.placeDetailsModel = placeDetailsModel
            cellsCreator?.dataSource = dataSource
        }
    }

    fileprivate var placeDetailsModel: PlaceDetails?
    fileprivate var cellsCreator: PlaceDetailsCellCreator?

    var allFish: Array<Fish>?
    var dataSource: DataSource?
    var currentLocation: CLLocation?

    var place: Place? {
        didSet {
            guard let place = place else { return }

            dataSource?.placeDetails(rechability: Reach.reachabilityForInternetConnection(), place: place, completionHandler: placeDetailsLoaded)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = self.place?.name;
    }

    @IBAction func navigateButtonPressed(_ sender: UIBarButtonItem) {
        if let dep = CLLocationManager().location,
            let destLat = placeDetailsModel?.lat,
            let ddestLon = placeDetailsModel?.lon {
            let dest = CLLocation(latitude: Double(destLat), longitude: Double(ddestLon))
            navigate(dep: dep, dest: dest)
        } else {
            let alert = AlertUtils.locationTurnedOffAlert()
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func navigate(dep: CLLocation, dest: CLLocation) {
        NavigationCoordinator().navigate(departure: dep.coordinate, destC: dest.coordinate)
    }

    private func placeDetailsLoaded(placeDetails: PlaceDetails?, cached: Bool) {
        loadingBlur?.isHidden = true

        guard let details = placeDetails else {
            noDataView?.isHidden = false
            return
        }
        self.placeDetailsModel = details
        navigationButton?.isEnabled = true

        cellsCreator?.placeDetailsModel = placeDetailsModel
        let cellFishModelArr = sortedCellFishModelArr()
        cellsCreator?.fishArray = cellFishModelArr

        loadPlaceFishImages(for: cellFishModelArr)
        loadPlaceImage()

        contentTable?.reloadData()
    }

    private func loadPlaceImage() {
        if let url = placeDetailsModel?.mainImgUrlStr {
            dataSource?.loadImages([url], completionHandler: { (url: String, image: UIImage?) in
                self.cellsCreator?.placeImage = image ?? UIImage(named: "defaultPlaceImage")
                self.contentTable?.reloadRows(at: [IndexPath(item: PlaceDetailsCellCreator.Cells.placeImage.rawValue, section: 0)], with: .fade)
            })
        } else {
            self.cellsCreator?.placeImage = UIImage(named: "defaultPlaceImage")
        }
    }

    private func goToPlacePhotosView() {
        let placePhotosController = self.storyboard!.instantiateViewController(withIdentifier: "PlaceImagesController") as? PlaceImagesController

        guard let photoUrls = placeDetailsModel?.photoUrls, photoUrls.count > 0 else { return }

        if let controller = placePhotosController {
            controller.setup(withUrlsArray: photoUrls, dataSource: dataSource)
            self.navigationController?.pushViewController(controller, animated: true)
            let backButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
        }
    }

    // Creates FishViewModel array based on information from allFish array and placeDetailsFish
    private func sortedCellFishModelArr() -> Array<FishViewModel> {
        var fishModelArr = Array<FishViewModel>()
        guard let placeDetailsFish = placeDetailsModel?.fish else { return fishModelArr }

        let _ = allFish?.forEach {
            let detailsId = $0.id
            let arr = placeDetailsFish.filter { $0.fishId == detailsId }

            if arr.count > 0 {
                let placeFish = arr[0]
                if let fishModel = FishViewModel(name: $0.name, amount: placeFish.amount, url: $0.iconUrl, image: nil) {
                    fishModelArr.append(fishModel)
                }
            }
        }
        return fishModelArr.sorted { return $0.amount > $1.amount }
    }

    private func loadPlaceFishImages(for fishViewModelArr: Array<FishViewModel>) {
        let iconUrlArr = fishViewModelArr.flatMap { $0.url }

        dataSource?.loadImages(iconUrlArr) { (url: String, image:UIImage?) in
            if let index = iconUrlArr.index(of: url),
                let fishModel = self.cellsCreator?.fishViewModel(at: index),
                let newModel = FishViewModel(name: fishModel.name, amount: fishModel.amount, url: url, image: image) {
                self.cellsCreator?.updateFishViewModel(at: index, with: newModel)
            }
        }
    }
}

extension PlaceDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellsCreator?.cell(forRowAtIndexPath: indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellsCreator?.cellEstimatedHeight(forRowAtIndexPath: indexPath) ?? UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellsCreator?.cellHeight(forRowAtIndexPath: indexPath) ?? UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsCreator?.rowsCount(inSection: section) ?? 0
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        contentTable.reloadData()
    }
}
