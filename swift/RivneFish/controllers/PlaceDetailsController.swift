//
//  PlaceDetailsController.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class PlaceDetailsController: UIViewController {

    var cellsCreator: PlaceDetailsCellCreator?
    var allFish: Array<Fish>?
    var cached: Bool = false
    var dataSource: DataSource?
    var currentLocation: CLLocation?

    var place: Place? {
        didSet {
            guard let place = place else { return }

            dataSource?.placeDetails(rechability: Reach.reachabilityForInternetConnection(), place: place) { placeDetails, cached in
                self.cached = cached
                if let details = placeDetails {
                    self.placeDetailsModel = details
                }
            }
        }
    }

    var placeDetailsModel: PlaceDetails? {
        didSet {
            // TODO:
            // validate()

            guard let placeDetailsFish = placeDetailsModel?.fish else { return }

            var fishViewModelArr = Array<FishViewModel>()

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

            fishArray = fishViewModelArr.sorted { return $0.amount > $1.amount }
            cellsCreator?.placeDetailsModel = placeDetailsModel
            contentTable?.reloadData()
        }
    }

    var fishArray: Array<FishViewModel>? {
        didSet {
            cellsCreator?.fishArray = fishArray
            
            contentTable?.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = self.placeDetailsModel?.name;
    }

    @IBOutlet weak var contentTable: UITableView! {
        didSet {
            cellsCreator = PlaceDetailsCellCreator(table: contentTable)
            cellsCreator?.placeDetailsModel = placeDetailsModel
            cellsCreator?.dataSource = dataSource
        }
    }

    @IBAction func navigateButtonPressed(_ sender: UIBarButtonItem) {
        if let currentCoordinate = currentLocation?.coordinate {
            navigate(currentCoordinate)
        } else {
            let title = NSLocalizedString("Ідентифікацію місцезнаходження вимкнено", comment: "Location turn off")
            let message = NSLocalizedString("Увімкніть доступ до геолокації в системних налаштуваннях цього пристрою щоб мати можливість використовувати навігацію до водойми:\n1. Системні налаштування\n2. rivnefish\n3. Місце", comment: "Please allow use location in system settings")
            let alert = AlertUtils.okeyAlertWith(title: title, message: message)
            self.present(alert, animated: true, completion: nil)
        }
    }

    fileprivate func navigate(_ destC: CLLocationCoordinate2D) {
        let location = CLLocationManager().location
        if let clat = location?.coordinate.latitude,
            let clon = location?.coordinate.longitude,
            let dlat = placeDetailsModel?.lat,
            let dlon = placeDetailsModel?.lon {
            let urlStr = "https://maps.apple.com?saddr=\(clat),\(clon)&daddr=\(dlat),\(dlon)"
            if let url = URL(string: urlStr) {
                UIApplication.shared.openURL(url)
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
