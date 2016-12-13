//
//  PlaceDetailsController.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class PlaceDetailsController: UIViewController {

    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var loadingBlur: UIVisualEffectView!
    @IBOutlet weak var noDataLabel: UILabel! {
        didSet {
            noDataLabel.textColor = Constants.Colors.kMain
            noDataLabel.text = "Помилка з'єднання. Перевірте мережу або спробуйте пізніше."
        }
    }

    @IBOutlet weak var contentTable: UITableView! {
        didSet {
            cellsCreator = PlaceDetailsCellCreator(table: contentTable)
            cellsCreator?.placeDetailsModel = placeDetailsModel
            cellsCreator?.dataSource = dataSource
        }
    }

    private var placeDetailsModel: PlaceDetails?
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
        loadingBlur.isHidden = true

        guard let details = placeDetails else {
            noDataView.isHidden = false
            return
        }
        self.placeDetailsModel = details

        cellsCreator?.placeDetailsModel = placeDetailsModel
        cellsCreator?.fishArray = sortedPlaceFish()
        contentTable?.reloadData()
    }

    private func sortedPlaceFish() -> Array<FishViewModel> {
        var fishViewModelArr = Array<FishViewModel>()
        guard let placeDetailsFish = placeDetailsModel?.fish else { return fishViewModelArr }

        let _ = allFish?.filter {
            let detailsId = $0.id
            let arr = placeDetailsFish.filter { $0.fishId == detailsId }

            if arr.count > 0 {
                let placeFish = arr[0]
                let viewModel = FishViewModel(name: $0.name, amount: placeFish.amount, image: $0.image)

                fishViewModelArr.append(viewModel)
                return true
            }
            return false
        }
        return fishViewModelArr.sorted { return $0.amount > $1.amount }
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
