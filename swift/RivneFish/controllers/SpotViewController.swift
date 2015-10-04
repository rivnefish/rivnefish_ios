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

    let kNavigationBarPortraitHeight: CGFloat = 64.0
    let kNavigationBarLandscapeHeight: CGFloat = 32.0

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placeCoordinatesLabel: UILabel!

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var fishCollectionView: UICollectionView!
    @IBOutlet weak var contentTextView: UITextView!

    @IBOutlet weak var imagesViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewRightMargin: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeftMargin: NSLayoutConstraint!

    @IBOutlet weak var contentTextViewHeight: NSLayoutConstraint!

    var imagesArray: Array<UIImage?>
    var imgUrlsArr: Array<String>!
    
    var fishImagesArray: Array<UIImage?>
    var fishImgUrlsArr: Array<String>!
    
    var fishArray: Array<Fish>! {
        didSet {
            if fishArray.count <= 0 {
                return
            }
            self.fishImgUrlsArr = Array<String>(count: fishArray.count, repeatedValue: String())
            for fish: Fish in fishArray {
                if let iconUrl: String = fish.iconUrl {
                    fishImgUrlsArr.append(iconUrl)
                }
            }
            fishImagesArray = [UIImage?](count: fishImgUrlsArr.count, repeatedValue: nil)

            loadImages(self.fishImgUrlsArr) { (index:Int, image:UIImage?) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.fishImagesArray[index] = image
                    if let collectionView = self.fishCollectionView {
                        collectionView.reloadItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
                    }
                }
            }
            // TODO: remove this
            dispatch_async(dispatch_get_main_queue(),{
                self.fishCollectionView.reloadData() })
        }
    }

    var marker: Marker! {
        didSet {
            self.imgUrlsArr = self.marker.photoUrls
            imagesArray = [UIImage?](count: imgUrlsArr.count, repeatedValue: nil)

            loadImages(self.imgUrlsArr) { (index:Int, image:UIImage?) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.imagesArray[index] = image
                    if let collectionView = self.imagesCollectionView {
                        collectionView.reloadItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
                    }
                }
            }
            updateContent()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        imagesArray = Array<UIImage>()
        imgUrlsArr = Array<String>()
        
        fishImagesArray = Array<UIImage>()
        fishImgUrlsArr = Array<String>()

        currentIndex = 0

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        setupFishCollectionView()

        setupImagesCollectionView()
        updateContent()
        updateImagesViewTopConstraint()
        updateLabels()
    }

    func updateContent() {
        if let content: String = marker.content {
            if let contentTextView = contentTextView {
                contentTextView.text = content
                updateContentTextViewHeight()
            }
        }
    }
    
    func updateLabels() {
        self.placeNameLabel.text = marker.name
        self.placeAddressLabel.text = marker.address
        self.placeCoordinatesLabel.text = "\(marker.lat), \(marker.lon)"
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
        self.contentTextViewHeight.constant = contentTextView.sizeThatFits(CGSize(width: self.view.frame.width - (self.contentViewRightMargin.constant + self.contentViewLeftMargin.constant), height: CGFloat.max)).height
        self.view.layoutIfNeeded()
    }
    
    func updateImagesView() {
        let offset = CGFloat(self.currentIndex) * self.imagesCollectionView.frame.size.width
        self.imagesCollectionView.contentOffset = CGPoint(x: offset, y: 0)
        UIView.animateWithDuration(0.15, animations: ({self.imagesCollectionView.alpha = 1.0}))
    }

    func updateImagesViewTopConstraint() {
        self.imagesViewTopConstraint.constant = (UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.Portrait ? kNavigationBarPortraitHeight : kNavigationBarLandscapeHeight)
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
            count = imgUrlsArr.count
        }
        else if collectionView == self.fishCollectionView {
            count = fishImgUrlsArr.count
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
            cell.image = fishImagesArray[indexPath.row]
            cell.updateCell()
            collectionViewCell = cell;
        }
        return collectionViewCell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == self.imagesCollectionView {
            return self.imagesCollectionView.frame.size
        } else if collectionView == self.fishCollectionView {
            return CGSize(width: 50, height: self.fishCollectionView.frame.height)
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
        updateImagesViewTopConstraint()
    }
}
