//
//  MarkerDetailsCellCreator.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 11/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class MarkerDetailsCellCreator {
    static let kPictureRatio:CGFloat = 4.0 / 3.0
    enum Cells: Int {
        case placeImages
        case fishImages
        case caption
        case contacts
        case placeDetails
        case fishingConditions
        case conveniences
        case description
        case linkCell
        case lastUpdateCell
    }

    let contentTable: UITableView
    var placeDetailsModel: PlaceDetails? {
        didSet {
            updateCellTypes()
        }
    }
    var cellTypes = Array<Cells>()
    var fishArray: Array<Fish>? {
        didSet {
            updateCellTypes()
        }
    }
    var dataSource: DataSource?

    init(table: UITableView) {
        self.contentTable = table
        self.registerCells()
    }

    fileprivate func registerCells() {
        var nibName = UINib(nibName: "PlaceImagesCell", bundle:nil)
        contentTable.register(nibName, forCellReuseIdentifier: "PlaceImagesCell")
        nibName = UINib(nibName: "FishImagesCell", bundle:nil)
        contentTable.register(nibName, forCellReuseIdentifier: "FishImagesCell")
        nibName = UINib(nibName: "AddressCell", bundle:nil)
        contentTable.register(nibName, forCellReuseIdentifier: "AddressCell")
        nibName = UINib(nibName: "ContactsCell", bundle:nil)
        contentTable.register(nibName, forCellReuseIdentifier: "ContactsCell")
        nibName = UINib(nibName: "TitleLabelCell", bundle:nil)
        contentTable.register(nibName, forCellReuseIdentifier: "TitleLabelCell")
        nibName = UINib(nibName: "PlaceDetailsCell", bundle:nil)
        contentTable.register(nibName, forCellReuseIdentifier: "PlaceDetailsCell")
        nibName = UINib(nibName: "FishingConditionsCell", bundle:nil)
        contentTable.register(nibName, forCellReuseIdentifier: "FishingConditionsCell")
        nibName = UINib(nibName: "ConveniencesCell", bundle:nil)
        contentTable.register(nibName, forCellReuseIdentifier: "ConveniencesCell")
        nibName = UINib(nibName: "LinkCell", bundle:nil)
        contentTable.register(nibName, forCellReuseIdentifier: "LinkCell")
        nibName = UINib(nibName: "ModifiedDateCell", bundle:nil)
        contentTable.register(nibName, forCellReuseIdentifier: "ModifiedDateCell")
    }

    fileprivate func updateCellTypes() {
        cellTypes.removeAll()

        let arr = placeDetailsModel?.photoUrls ?? Array()
        if !arr.isEmpty {
            cellTypes.append(.placeImages)
        }
        let fish = fishArray ?? Array()
        if !fish.isEmpty {
            cellTypes.append(.fishImages)
        }
        let name = placeDetailsModel?.name ?? ""
        if !name.isEmpty {
            cellTypes.append(.caption)
        }
        let contact = placeDetailsModel?.contact ?? ""
        let contactName = placeDetailsModel?.contactName ?? ""
        if !contact.isEmpty || !contactName.isEmpty {
            cellTypes.append(.contacts)
        }
        let area = placeDetailsModel?.areaStr ?? ""
        let averDepth = placeDetailsModel?.averageDepth ?? ""
        let maxDepth = placeDetailsModel?.maxDepth ?? ""
        if !area.isEmpty || !averDepth.isEmpty || !maxDepth.isEmpty {
            cellTypes.append(.placeDetails)
        }
        let price = placeDetailsModel?.paidFish ?? ""
        let boat = placeDetailsModel?.boatUsageReadable ?? ""
        let time = placeDetailsModel?.timeToFishStr ?? ""
        if !price.isEmpty || !boat.isEmpty || !time.isEmpty {
            cellTypes.append(.fishingConditions)
        }
        let convenieces = placeDetailsModel?.conveniences ?? ""
        if !convenieces.isEmpty {
            cellTypes.append(.conveniences)
        }
        let content = placeDetailsModel?.content ?? ""
        if !content.isEmpty {
            cellTypes.append(.description)
        }
        let lastUpdate = placeDetailsModel?.modifyDate ?? ""
        if !lastUpdate.isEmpty {
            cellTypes.append(.lastUpdateCell)
        }
        let urlStr = placeDetailsModel?.url ?? ""
        if !urlStr.isEmpty {
            cellTypes.append(.linkCell)
        }
    }

    func cell(forRowAtIndexPath indexPath: IndexPath) -> UITableViewCell? {
        let cell: UITableViewCell?
        let cellType = cellTypes[(indexPath as NSIndexPath).row]
        switch cellType {
        case .placeImages:
            cell = placeImagesCell(forIndexPath: indexPath)
        case .fishImages:
            cell = fishImagesCell(forIndexPath: indexPath)
        case .caption:
            cell = captionCell(forIndexPath: indexPath)
        case .contacts:
            cell = contactsCell(forIndexPath: indexPath)
        case .placeDetails:
            cell = placeDetailsCell(forIndexPath: indexPath)
        case.fishingConditions:
            cell = fishingConditionsCell(forIndexPath: indexPath)
        case .conveniences:
            cell = conveniencesCell(forIndexPath: indexPath)
        case .description:
            cell = descriptionCell(forIndexPath: indexPath)
        case .linkCell:
            cell = linkCell(forIndexPath: indexPath)
        case .lastUpdateCell:
            cell = lastUpdateCell(forIndexPath: indexPath)
        }
        return cell
    }

    func cellEstimatedHeight(forRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellType = cellTypes[(indexPath as NSIndexPath).row]
        switch cellType {
        case .placeImages:
            return placeImagesCellHeight()
        case .fishImages:
            return FishImagesCell.kFishCellWidth
        default:
            return UITableViewAutomaticDimension
        }
    }

    func cellHeight(forRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellType = cellTypes[(indexPath as NSIndexPath).row]
        switch cellType {
        case .placeImages:
            return placeImagesCellHeight()
        case .fishImages:
            return FishImagesCell.kFishCellWidth
        default:
            return UITableViewAutomaticDimension
        }
    }

    fileprivate func placeImagesCellHeight() -> CGFloat {
        let max = self.contentTable.frame.height - FishImagesCell.kFishCellWidth
        let h = self.contentTable.frame.width / MarkerDetailsCellCreator.kPictureRatio
        return h < max ? h : max
    }

    func rowsCount(inSection section: Int) -> Int {
        return cellTypes.count
    }

    func placeImagesCell(forIndexPath indexPath: IndexPath) -> PlaceImagesCell? {
        if let cell = contentTable.dequeueReusableCell(withIdentifier: "PlaceImagesCell", for: indexPath) as? PlaceImagesCell,
            let arr = placeDetailsModel?.photoUrls {
            cell.setup(withUrlsArray: arr, dataSource: dataSource)
            return cell
        }
        return nil
    }

    func fishImagesCell(forIndexPath indexPath: IndexPath) -> FishImagesCell? {
        if let cell = contentTable.dequeueReusableCell(withIdentifier: "FishImagesCell", for: indexPath) as? FishImagesCell,
            let fishArr = fishArray {
            cell.setup(withFishArray: fishArr)
            return cell
        }
        return nil
    }

    func contactsCell(forIndexPath indexPath: IndexPath) -> ContactsCell? {
        if let cell = contentTable.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as? ContactsCell {
            cell.setup(withPhone: placeDetailsModel?.contact, details: placeDetailsModel?.contactName)
            return cell
        }
        return nil
    }

    func descriptionCell(forIndexPath indexPath: IndexPath) -> TitleLabelCell? {
        if let cell = contentTable.dequeueReusableCell(withIdentifier: "TitleLabelCell", for: indexPath) as? TitleLabelCell {
            cell.setup(withTitle: "Опис", text: placeDetailsModel?.content)
            return cell
        }
        return nil
    }

    func captionCell(forIndexPath indexPath: IndexPath) -> AddressCell? {
        if let cell = contentTable.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as? AddressCell {
            cell.setup(withName: nil, address: placeDetailsModel?.address, coordinates: "\(placeDetailsModel?.lat ?? 0), \(placeDetailsModel?.lon ?? 0)")
            return cell
        }
        return nil
    }

    func fishingConditionsCell(forIndexPath indexPath: IndexPath) -> FishingConditionsCell? {
        if let cell = contentTable.dequeueReusableCell(withIdentifier: "FishingConditionsCell", for: indexPath) as? FishingConditionsCell {
            cell.setup(withMainInfo: placeDetailsModel?.permitStr, payment: placeDetailsModel?.paidFish, boatUsage: placeDetailsModel?.boatUsageReadable, fishingTime: placeDetailsModel?.timeToFishStr)
            return cell
        }
        return nil
    }

    func conveniencesCell(forIndexPath indexPath: IndexPath) -> ConveniencesCell? {
        if let cell = contentTable.dequeueReusableCell(withIdentifier: "ConveniencesCell", for: indexPath) as? ConveniencesCell {
            cell.setup(withTitle: "Умови відпочинку:", text: placeDetailsModel?.conveniences)
            return cell
        }
        return nil
    }

    func placeDetailsCell(forIndexPath indexPath: IndexPath) -> PlaceDetailsCell? {
        if let cell = contentTable.dequeueReusableCell(withIdentifier: "PlaceDetailsCell", for: indexPath) as? PlaceDetailsCell {
            cell.setup(withSquare: placeDetailsModel?.areaStr, averageDepth: placeDetailsModel?.averageDepthReadable, maxDepth: placeDetailsModel?.maxDepthReadable)
            return cell
        }
        return nil
    }

    func linkCell(forIndexPath indexPath: IndexPath) -> LinkCell? {
        if let cell = contentTable.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as? LinkCell {
            if let urlStr = placeDetailsModel?.url {
                cell.setup(withLinkText: "Переглянути на сайті rivnefish", urlString: urlStr)
                return cell
            }
        }
        return nil
    }

    func lastUpdateCell(forIndexPath indexPath: IndexPath) -> ModifiedDateCell? {
        if let cell = contentTable.dequeueReusableCell(withIdentifier: "ModifiedDateCell", for: indexPath) as? ModifiedDateCell {
            if let text = placeDetailsModel?.modifyDateLocalized {
                cell.setupWithText("Востаннє ця інформація оновлювалась: " + text)
                return cell
            }
        }
        return nil
    }
}
