//
//  MarkerDetailsCellCreator.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 11/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class PlaceDetailsCellCreator {
    static let kDefaultPictureRatio:CGFloat = 4.0 / 3.0
    enum Cells: Int {
        case placeImage
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
    var fishArray: Array<FishViewModel>? {
        didSet {
            updateCellTypes()
        }
    }
    var dataSource: DataSource?
    var placeImage: UIImage?
    private var selectPlaceImageHandler: EmptyClosure?

    init(table: UITableView, selectPlaceImageHandler: EmptyClosure? = nil) {
        self.contentTable = table
        self.selectPlaceImageHandler = selectPlaceImageHandler
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
        nibName = UINib(nibName: "PlaceImageCell", bundle:nil)
        contentTable.register(nibName, forCellReuseIdentifier: "PlaceImageCell")
    }

    fileprivate func updateCellTypes() {
        cellTypes.removeAll()

        let arr = placeDetailsModel?.photoUrls ?? Array()
        if !arr.isEmpty {
            cellTypes.append(.placeImage)
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
        let price = placeDetailsModel?.priceNotes ?? ""
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
        let lastUpdate = placeDetailsModel?.modifiedDate ?? ""
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
        case .placeImage:
            cell = placeImageCell(forIndexPath: indexPath)
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
        case .placeImage:
            return placeImageCellHeight()
        case .fishImages:
            return FishImagesCell.kFishCellWidth
        default:
            return UITableViewAutomaticDimension
        }
    }

    func cellHeight(forRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellType = cellTypes[(indexPath as NSIndexPath).row]
        switch cellType {
        case .placeImage:
            return placeImageCellHeight()
        case .fishImages:
            return FishImagesCell.kFishCellWidth
        default:
            return UITableViewAutomaticDimension
        }
    }

    fileprivate func placeImageCellHeight() -> CGFloat {
        let max = self.contentTable.frame.height - FishImagesCell.kFishCellWidth

        var pictureRatio = PlaceDetailsCellCreator.kDefaultPictureRatio
        if let img = placeImage {
            pictureRatio = img.size.width / img.size.height
        }

        let h = self.contentTable.frame.width / pictureRatio
        return h < max ? h : max
    }

    func rowsCount(inSection section: Int) -> Int {
        return cellTypes.count
    }

    func placeImageCell(forIndexPath indexPath: IndexPath) -> PlaceImageCell? {
        guard let cell = contentTable.dequeueReusableCell(withIdentifier: "PlaceImageCell", for: indexPath) as? PlaceImageCell else {
            return nil
        }
        cell.setup(withImage: placeImage, selectCellAction: selectPlaceImageHandler)
        return cell
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
            cell.setup(withTitle: "Опис", text: placeDetailsModel?.content, isAttributedText: false)
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
            cell.setup(withMainInfo: placeDetailsModel?.permitStr, payment: placeDetailsModel?.priceNotes, boatUsage: placeDetailsModel?.boatUsageReadable, fishingTime: placeDetailsModel?.timeToFishStr)
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
                cell.setupWithText("Востаннє інформація оновлювалась: " + text)
                return cell
            }
        }
        return nil
    }
}
