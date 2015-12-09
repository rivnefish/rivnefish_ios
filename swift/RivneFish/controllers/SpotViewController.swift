//
//  SpotViewController.swift
//  RivneFish
//
//  Created by akyryl on 06/09/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit

class SpotViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITextViewDelegate {
    
    var currentIndex: Int
    let kCellIdentifier = "imagesCellIdentifier"
    let kFishCellIdentifier = "fishImagesCellIdentifier"
    let kFishCellWidth: CGFloat = 70.0

    let kFishViewHeight: CGFloat = 70.0
    let kContentViewHeight: CGFloat = 1.0
    let kDetailViewExpandedHeight: CGFloat = 144.0
    let kDetailViewClosedHeight: CGFloat = 22.0
    let kImageAspectRatioIndex: CGFloat = 1.33333
    let kMaxImagesCollectionViewHeight: CGFloat = CGFloat(768.0) / 1.33333

    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placeCoordinatesLabel: UILabel!
    
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var squareLabel: UILabel!
    @IBOutlet weak var averageDepthLabel: UILabel!
    @IBOutlet weak var maxDepthLabel: UILabel!
    @IBOutlet weak var boatUsageLabel: UILabel!
    @IBOutlet weak var detailUrlLabel: UILabel!
    @IBOutlet weak var permitLabel: UILabel!

    @IBOutlet weak var expandDetailInfoButton: UIButton!

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var fishCollectionView: UICollectionView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var fishingInfoView: UITextView!

    @IBOutlet weak var imagesViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewRightMargin: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeftMargin: NSLayoutConstraint!

    @IBOutlet weak var fishViewHeightContraint: NSLayoutConstraint!

    @IBOutlet weak var detailedInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLineViewHeightContraint: NSLayoutConstraint!

    @IBOutlet weak var fishingInfoViewLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var fishingInfoViewRightMargin: NSLayoutConstraint!
    @IBOutlet weak var fishingInfoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fuckingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fishViewTopMarginConstraint: NSLayoutConstraint!

    var detailedViewExpanded = false

    var imagesArray: Array<UIImage?>
    var imgUrlsArr: Array<String>!
    
    var fishArray: Array<Fish>? {
        didSet {
            if fishArray == nil || fishArray!.count <= 0 {
                return
            }
            
            // Make fish collection view know fish count (cells count) before updating each cell by index
            dispatch_async(dispatch_get_main_queue(),{
                self.fishCollectionView.reloadData()
            })
            // Do not load fish from server, use resouces icons
            // self.loadFishFromServer()
        }
    }
    
    func loadFishFromServer() {
        // Get img url strings array
        var fishImgUrlsArr: Array<String> = Array<String>()
        fishImgUrlsArr.reserveCapacity(fishArray!.count)
        for fish: Fish in fishArray! {
            if let iconUrl: String = fish.iconUrl {
                fishImgUrlsArr.append(iconUrl)
            } else {
                fishImgUrlsArr.append("")
            }
        }
        
        // Load images and update view
        loadImages(fishImgUrlsArr) { (index: Int, image: UIImage?) in
            dispatch_async(dispatch_get_main_queue()) {
                
                self.fishArray![index].image = image
                if let collectionView = self.fishCollectionView {
                    collectionView.reloadItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(),{
            self.updateFishViewVisibility()
            self.updateContent()
            self.updateFishingInfoView()
        })
    }

    var marker: MarkerModel! {
        didSet {
            self.imgUrlsArr = self.marker.photoUrls

            updateImagesViewHeight()
            updateContentLineVisibilty()

            imagesArray = [UIImage?](count: imgUrlsArr.count, repeatedValue: nil)

            // Make images collection view to know images count (cells count) before updating each cell by index
            dispatch_async(dispatch_get_main_queue(),{
                self.imagesCollectionView.reloadData()
            })

            // Load images and update collection view
            loadImages(self.imgUrlsArr) { (index:Int, image:UIImage?) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.imagesArray[index] = image
                    if let collectionView = self.imagesCollectionView {
                        collectionView.reloadItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(),{
                self.updateContent()
                self.updateFishingInfoView()
            })
        }
    }

    required init?(coder aDecoder: NSCoder) {
        imagesArray = Array<UIImage>()
        imgUrlsArr = Array<String>()
        
        currentIndex = 0

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        updateImagesViewHeight()
        updateFishViewVisibility()
        updateContentLineVisibilty()
        
        setupFishCollectionView()

        setupImagesCollectionView()
        updateImagesViewTopConstraint()
        updateLabels()
        
        // if just does not work from story board
        fuckingConstraint.constant = 20
        updateContent()
        updateFishingInfoView()
    }

    override func viewWillAppear(animated: Bool) {
        self.updateImagesViewHeight()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = self.marker.name;
    }

    @IBAction func urlButtonTouched(sender: UIButton) {
        if let urlStr = marker.url {
            let url = NSURL(string: urlStr)
            if let validUrl = url {
                UIApplication.sharedApplication().openURL(validUrl)
            }
        }
    }

    func updateImagesViewHeight() {
        if let contraint = imagesViewHeightContraint {
            contraint.constant = 0
            if let arr = imgUrlsArr {
                if arr.count > 0 {
                    contraint.constant = imagesViewHeight()
                }
            }
        }
    }
    
    func imagesViewHeight() -> CGFloat {
        let height: CGFloat = self.imagesCollectionView.frame.width / kImageAspectRatioIndex
        
        var maxImagesViewPossibleHeight: CGFloat = 0
        if let navBarHeight = self.navigationController?.navigationBar.frame.height {
            maxImagesViewPossibleHeight = UIScreen.mainScreen().bounds.height - (navBarHeight + self.fishCollectionView.frame.height + fishViewTopMarginConstraint.constant)
        }
        let max = maxImagesViewPossibleHeight < kMaxImagesCollectionViewHeight ? maxImagesViewPossibleHeight : kMaxImagesCollectionViewHeight
        return height <= max ? height : max
    }

    func updateFishViewVisibility() {
        // TODO: do not change fish view height if there is no fish data for now
        return
        if let contraint = fishViewHeightContraint {
            contraint.constant = 0
            if let arr = fishArray {
                if arr.count > 0 {
                    contraint.constant = kFishViewHeight
                }
            }
        }
    }

    func updateContentLineVisibilty() {
        if let contraint = descriptionLineViewHeightContraint {
            descriptionLineViewHeightContraint.constant = 0
            if let content: String = marker.content {
                if !content.isEmpty {
                    contraint.constant = kContentViewHeight
                }
            }
        }
    }

    func updateContent() {
        if let content: String = marker.content {
            if let contentTextView = contentTextView {
                if !content.isEmpty {
                    contentTextView.text = content
                }
            }
        }
        updateContentTextViewHeight()
    }
    
    func updateFishingInfoView() {
        if let content: String = marker.paidFish {
            if let view = fishingInfoView {
                if !content.isEmpty {
                    view.text = NSLocalizedString("Умови риболовлі: ", comment: "Paid Fish Preffix") + content
                }
            }
        }
        updateFishingInfoViewHeight()
    }


    func updateLabels() {
        self.placeAddressLabel.text = marker.address
        self.placeCoordinatesLabel.text = "\(marker.lat), \(marker.lon)"

        self.contactLabel.text = marker.contactStr
        self.squareLabel.text = marker.areaStr
        self.maxDepthLabel.text = marker.maxDepthStr
        self.averageDepthLabel.text = marker.averageDepthStr
        self.boatUsageLabel.text = marker.boatUsaveStr
        self.permitLabel.text = marker.permitStr
    }

    func loadImages(urlsArr: Array<String>?, continuation: ((Int, UIImage?) -> Void)) {
        if let urlStringArr = urlsArr {
            var i: Int = 0
            for urlString in urlStringArr {
                if let url = NSURL(string: urlString) {
                    getDataFromUrl(url, index: i) { data, index in
                        if let data = NSData(contentsOfURL: url) {
                            continuation(index, UIImage(data: data))
                        }
                    }
                }
                ++i
            }
        }
    }

    func getDataFromUrl(urL: NSURL, index: Int, completion: ((data: NSData?, index: Int) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data, index: index)
            }.resume()
    }
    
    // Lyout helper methods
    
    func updateContentTextViewHeight() {
        if contentTextView != nil {
            if contentTextView.text.isEmpty {
                self.contentTextViewHeight.constant = 0
            } else {
                self.contentTextViewHeight.constant = contentTextView.sizeThatFits(CGSize(width: self.view.frame.width - (self.contentViewRightMargin.constant + self.contentViewLeftMargin.constant), height: CGFloat.max)).height
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func updateFishingInfoViewHeight() {
        if fishingInfoView != nil {
            if fishingInfoView.text.isEmpty {
                self.fishingInfoViewHeight.constant = 0
            } else {
                self.fishingInfoViewHeight.constant = fishingInfoView.sizeThatFits(CGSize(width: self.view.frame.width - (self.fishingInfoViewRightMargin.constant + self.fishingInfoViewLeftMargin.constant), height: CGFloat.max)).height
            }
            self.view.layoutIfNeeded()
        }
    }

    func updateImagesView() {
        let offset = CGFloat(self.currentIndex) * self.imagesCollectionView.frame.size.width
        self.imagesCollectionView.contentOffset = CGPoint(x: offset, y: 0)
        UIView.animateWithDuration(0.15, animations: ({self.imagesCollectionView.alpha = 1.0}))
    }

    func updateImagesViewTopConstraint() {
        if let height = self.navigationController?.navigationBar.frame.size.height {
            self.imagesViewTopConstraint.constant = height + UIApplication.sharedApplication().statusBarFrame.size.height
        }
    }

    // UICollectionView methods

    func setupImagesCollectionView() {
        self.imagesCollectionView.registerNib(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)

        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0

        self.imagesCollectionView.collectionViewLayout = flowLayout;
        self.imagesCollectionView.pagingEnabled = true
    }
    
    func setupFishCollectionView() {
        self.fishCollectionView.registerNib(UINib(nibName: "FishCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kFishCellIdentifier)
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0

        self.fishCollectionView.collectionViewLayout = flowLayout;
        self.fishCollectionView.pagingEnabled = true
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == self.imagesCollectionView {
            if let arr = imgUrlsArr {
                count = arr.count
            }
        }
        else if collectionView == self.fishCollectionView {
            if let arr = fishArray {
                count = arr.count
            }
        }
        return count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var collectionViewCell = UICollectionViewCell()
        if collectionView == self.imagesCollectionView {
            let cell: ImagesCollectionViewCell = self.imagesCollectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! ImagesCollectionViewCell
            cell.image = imagesArray[indexPath.row]
            cell.updateCell()
            collectionViewCell = cell;
        } else if collectionView == self.fishCollectionView {
            let cell: FishCollectionViewCell = self.fishCollectionView.dequeueReusableCellWithReuseIdentifier(kFishCellIdentifier, forIndexPath: indexPath) as! FishCollectionViewCell
            if let fish = fishArray?[indexPath.row] {
                cell.image = fish.image
                cell.name = fish.ukrName
                if let amount = fish.amount {
                    cell.amount = amount
                }
            }
            cell.updateCell()
            collectionViewCell = cell;
        }
        return collectionViewCell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == self.imagesCollectionView {
            return self.imagesCollectionView.frame.size
        } else if collectionView == self.fishCollectionView {
            return CGSize(width: kFishCellWidth, height: self.fishCollectionView.frame.height)
        }
        return CGSize(width: 0.0, height: 0.0)
    }

    // Rotation handling methods

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.imagesCollectionView.alpha = 0.0
        self.imagesCollectionView.collectionViewLayout.invalidateLayout()
        self.currentIndex = Int(self.imagesCollectionView.contentOffset.x / self.imagesCollectionView.frame.size.width)
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        updateImagesView()
        updateContentTextViewHeight()
        updateFishingInfoViewHeight()
        updateImagesViewTopConstraint()
        updateImagesViewHeight()
    }

    @IBAction func expandButtonTouched(sender: UIButton) {
        detailedViewExpanded = !detailedViewExpanded
        let animationDuration = 0.3
        UIView.animateWithDuration(animationDuration, animations: {
            self.detailedInfoViewHeightConstraint.constant = self.detailedViewExpanded ? self.kDetailViewExpandedHeight : self.kDetailViewClosedHeight
            self.view.layoutIfNeeded()
        })
        
        UIView.animateWithDuration(animationDuration, animations:{
            let transform = self.detailedViewExpanded ? CGAffineTransformMakeRotation(CGFloat(M_PI)) : CGAffineTransformMakeRotation(CGFloat(0))
            self.expandDetailInfoButton.transform = transform
        })
    }
}
