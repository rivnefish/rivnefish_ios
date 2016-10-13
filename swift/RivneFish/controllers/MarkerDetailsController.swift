//
//  MarkerDetailsController.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class MarkerDetailsController: UIViewController {
    var cellsCreator: MarkerDetailsCellCreator?

    var markerDetailsModel: MarkerModel? {
        didSet {
            validate()
            loadFishList()

            cellsCreator?.markerDetailsModel = markerDetailsModel
            contentTable?.reloadData()
        }
    }
    var dataSource: DataSource?
    var fishArray: Array<Fish>? {
        didSet {
            cellsCreator?.fishArray = fishArray
            contentTable?.reloadData()
        }
    }
    var currentLocation: CLLocation?

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = self.markerDetailsModel?.name;
    }

    @IBOutlet weak var contentTable: UITableView! {
        didSet {
            cellsCreator = MarkerDetailsCellCreator(table: contentTable)
            cellsCreator?.markerDetailsModel = markerDetailsModel
            cellsCreator?.dataSource = dataSource
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

    fileprivate func validate() {
        if let model = markerDetailsModel,
            let source = dataSource ,
            false == ActualityValidator.actualityValidator.markerUpToDate(model) {
            source.removeMarkerCachedImages(model)
        }
    }

    fileprivate func loadFishList() {
        guard let model = markerDetailsModel else { return }

        dataSource?.fishForMarker(Reach.reachabilityForInternetConnection(), marker: model, completionHandler: { (fish: NSArray) in
            self.fishArray = fish as? Array<Fish>
        })
    }

    fileprivate func navigate(_ destC: CLLocationCoordinate2D) {
        let location = CLLocationManager().location
        if let clat = location?.coordinate.latitude,
            let clon = location?.coordinate.longitude,
            let dlat = markerDetailsModel?.lat,
            let dlon = markerDetailsModel?.lon {
            let urlStr = "https://maps.apple.com?saddr=\(clat),\(clon)&daddr=\(dlat),\(dlon)"
            if let url = URL(string: urlStr) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension MarkerDetailsController: UITableViewDelegate, UITableViewDataSource {
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
