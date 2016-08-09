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
        case Caption = 0
        case Contacts = 1
        case PlaceDetails = 2
        case FishingConditions = 3
        case Description = 4
        case LinkCell = 5
    }

    var markerDetailsModel: MarkerModel? {
        didSet {
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
            contentTable?.reloadData()
        }
    }

    var cellTypes = Array<Cells>()

    override func viewDidLoad() {
        contentTable?.reloadData()
    }

    @IBOutlet weak var contentTable: UITableView! {
        didSet {
            var nibName = UINib(nibName: "LabelCell", bundle:nil)
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
            contentTable.registerNib(nibName, forCellReuseIdentifier:
                "FishingConditionsCell")
            nibName = UINib(nibName: "LinkCell", bundle:nil)
            contentTable.registerNib(nibName, forCellReuseIdentifier: "LinkCell")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension MarkerDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        let cellType = cellTypes[indexPath.row]
        switch cellType {
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
