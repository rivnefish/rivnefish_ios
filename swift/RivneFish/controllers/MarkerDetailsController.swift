//
//  MarkerDetailsController.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 07/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class MarkerDetailsController: UIViewController {

    enum Cells: Int {
        case PlaceImages = 0
        case FishImages = 1
        case Caption = 2
        case Contacts = 3
        case PlaceDetails = 4
        case FishingConditions = 5
        case Description = 6
        case LinkCell = 7
    }

    var markerDetailsModel: MarkerModel? {
        didSet {
            loadFishList()
            updateCellTypes()
            contentTable?.reloadData()
        }
    }

    var cellTypes = Array<Cells>()
    var dataSource: DataSource?
    var fishArray: Array<Fish>? {
        didSet {
            updateCellTypes()
            contentTable?.reloadData()
        }
    }

    override func viewDidLoad() {
        contentTable?.reloadData()
    }

    @IBOutlet weak var contentTable: UITableView! {
        didSet {
            var nibName = UINib(nibName: "PlaceImagesCell", bundle:nil)
            contentTable.registerNib(nibName, forCellReuseIdentifier: "PlaceImagesCell")
            nibName = UINib(nibName: "FishImagesCell", bundle:nil)
            contentTable.registerNib(nibName, forCellReuseIdentifier: "FishImagesCell")
            nibName = UINib(nibName: "LabelCell", bundle:nil)
            contentTable.registerNib(nibName, forCellReuseIdentifier: "LabelCell")
            nibName = UINib(nibName: "AddressCell", bundle:nil)
            contentTable.registerNib(nibName, forCellReuseIdentifier: "AddressCell")
            nibName = UINib(nibName: "ContactsCell", bundle:nil)
            contentTable.registerNib(nibName, forCellReuseIdentifier: "ContactsCell")
            nibName = UINib(nibName: "TitleLabelCell", bundle:nil)
            contentTable.registerNib(nibName, forCellReuseIdentifier: "TitleLabelCell")
            nibName = UINib(nibName: "PlaceDetailsCell", bundle:nil)
            contentTable.registerNib(nibName, forCellReuseIdentifier: "PlaceDetailsCell")
            nibName = UINib(nibName: "FishingConditionsCell", bundle:nil)
            contentTable.registerNib(nibName, forCellReuseIdentifier: "FishingConditionsCell")
            nibName = UINib(nibName: "LinkCell", bundle:nil)
            contentTable.registerNib(nibName, forCellReuseIdentifier: "LinkCell")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func updateCellTypes() {
        cellTypes.removeAll()

        let arr = markerDetailsModel?.photoUrls ?? Array()
        if !arr.isEmpty {
            cellTypes.append(.PlaceImages)
        }
        let fish = fishArray ?? Array()
        if !fish.isEmpty {
            cellTypes.append(.FishImages)
        }
        let name = markerDetailsModel?.name ?? ""
        if !name.isEmpty {
            cellTypes.append(.Caption)
        }
        let contact = markerDetailsModel?.contact ?? ""
        let contactName = markerDetailsModel?.contactName ?? ""
        if !contact.isEmpty || !contactName.isEmpty {
            cellTypes.append(.Contacts)
        }
        let area = markerDetailsModel?.areaStr ?? ""
        let averDepth = markerDetailsModel?.averageDepth ?? ""
        let maxDepth = markerDetailsModel?.maxDepth ?? ""
        if !area.isEmpty || !averDepth.isEmpty || !maxDepth.isEmpty {
            cellTypes.append(.PlaceDetails)
        }
        let price24 = markerDetailsModel?.price24 ?? ""
        let boat = markerDetailsModel?.boatUsageStr ?? ""
        let time = markerDetailsModel?.timeToFish ?? ""
        if !price24.isEmpty || !boat.isEmpty || !time.isEmpty {
            cellTypes.append(.FishingConditions)
        }
        let content = markerDetailsModel?.content ?? ""
        if !content.isEmpty {
            cellTypes.append(.Description)
        }
        let urlStr = markerDetailsModel?.url ?? ""
        if !urlStr.isEmpty {
            cellTypes.append(.LinkCell)
        }
    }

    private func loadFishList() {
        guard let model = markerDetailsModel else { return }

        dataSource?.fishForMarker(Reach.reachabilityForInternetConnection(), marker: model, completionHandler: { (fish: NSArray) in
            // TODO: move dispatch to datasource
            dispatch_async(dispatch_get_main_queue(),{
                self.fishArray = fish as? Array<Fish>
            })
        })
    }
}

extension MarkerDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        let cellType = cellTypes[indexPath.row]
        switch cellType {
        case .PlaceImages:
            cell = placeImagesCell(forIndexPath: indexPath)
        case .FishImages:
            cell = fishImagesCell(forIndexPath: indexPath)
        case .Caption:
            cell = captionCell(forIndexPath: indexPath)
        case .Contacts:
            cell = contactsCell(forIndexPath: indexPath)
        case .PlaceDetails:
            cell = placeDetailsCell(forIndexPath: indexPath)
        case.FishingConditions:
            cell = fishingConditionsCell(forIndexPath: indexPath)
        case .Description:
            cell = descriptionCell(forIndexPath: indexPath)
        case .LinkCell:
            cell = linkCell(forIndexPath: indexPath)
        }
        return cell ?? UITableViewCell()
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }

    private func placeImagesCell(forIndexPath indexPath: NSIndexPath) -> PlaceImagesCell? {
        if let cell = contentTable.dequeueReusableCellWithIdentifier("PlaceImagesCell", forIndexPath: indexPath) as? PlaceImagesCell,
            let arr = markerDetailsModel?.photoUrls {
            cell.setup(withUrlsArray: arr, dataSource: dataSource)
            return cell
        }
        return nil
    }

    private func fishImagesCell(forIndexPath indexPath: NSIndexPath) -> FishImagesCell? {
        if let cell = contentTable.dequeueReusableCellWithIdentifier("FishImagesCell", forIndexPath: indexPath) as? FishImagesCell,
            let fishArr = fishArray {
            cell.setup(withFishArray: fishArr)
            return cell
        }
        return nil
    }

    private func contactsCell(forIndexPath indexPath: NSIndexPath) -> ContactsCell? {
        if let cell = contentTable.dequeueReusableCellWithIdentifier("ContactsCell", forIndexPath: indexPath) as? ContactsCell {
            cell.setup(withPhone: markerDetailsModel?.contact, details: markerDetailsModel?.contactName)
            return cell
        }
        return nil
    }

    private func descriptionCell(forIndexPath indexPath: NSIndexPath) -> TitleLabelCell? {
        if let cell = contentTable.dequeueReusableCellWithIdentifier("TitleLabelCell", forIndexPath: indexPath) as? TitleLabelCell {
            cell.setup(withTitle: "Опис", text: markerDetailsModel?.content)
            return cell
        }
        return nil
    }

    private func captionCell(forIndexPath indexPath: NSIndexPath) -> AddressCell? {
        if let cell = contentTable.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as? AddressCell {
            cell.setup(withName: markerDetailsModel?.name, address: markerDetailsModel?.address, coordinates: "\(markerDetailsModel?.lat ?? 0), \(markerDetailsModel?.lon ?? 0)")
            return cell
        }
        return nil
    }

    private func fishingConditionsCell(forIndexPath indexPath: NSIndexPath) -> FishingConditionsCell? {
        if let cell = contentTable.dequeueReusableCellWithIdentifier("FishingConditionsCell", forIndexPath: indexPath) as? FishingConditionsCell {
            cell.setup(withPayment: markerDetailsModel?.price24, boatUsage: markerDetailsModel?.boatUsageStr, fishingTime: markerDetailsModel?.timeToFish)
            return cell
        }
        return nil
    }

    private func placeDetailsCell(forIndexPath indexPath: NSIndexPath) -> PlaceDetailsCell? {
        if let cell = contentTable.dequeueReusableCellWithIdentifier("PlaceDetailsCell", forIndexPath: indexPath) as? PlaceDetailsCell {
            cell.setup(withSquare: markerDetailsModel?.areaStr, averageDepth: markerDetailsModel?.averageDepth, maxDepth: markerDetailsModel?.maxDepth)
            return cell
        }
        return nil
    }

    private func linkCell(forIndexPath indexPath: NSIndexPath) -> LinkCell? {
        if let cell = contentTable.dequeueReusableCellWithIdentifier("LinkCell", forIndexPath: indexPath) as? LinkCell {
            if let urlStr = markerDetailsModel?.url {
                cell.setup(withLinkText: "Детальніше", urlString: urlStr)
                return cell
            }
        }
        return nil
    }
}