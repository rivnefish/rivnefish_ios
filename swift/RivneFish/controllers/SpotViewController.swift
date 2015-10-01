//
//  SpotViewController.swift
//  RivneFish
//
//  Created by akyryl on 06/09/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit

class SpotViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITextViewDelegate {
    
    let kNavigationBarPortraitHeight: CGFloat = 64.0
    let kNavigationBarLandscapeHeight: CGFloat = 32.0

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placeCoordinatesLabel: UILabel!

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var FishCollectionView: UICollectionView!
    @IBOutlet weak var contentTextView: UITextView!

    @IBOutlet weak var imagesViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewRightMargin: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeftMargin: NSLayoutConstraint!

    @IBOutlet weak var contentTextViewHeight: NSLayoutConstraint!

    var imagesArray: Array<UIImage?>!
    var imgUrlsArr: Array<String>!

    var marker: Marker! {
        didSet {
            self.imgUrlsArr = self.marker.photoUrls

            imagesArray = [UIImage?](count: imgUrlsArr.count, repeatedValue: nil)
            loadImages()
            updateContent()
        }
    }

    var currentIndex: Int
    let kCellIdentifier = "cellIdentifier"

    required init?(coder aDecoder: NSCoder) {
        imagesArray = Array<UIImage>()
        imgUrlsArr = Array<String>()
        currentIndex = 0

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
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

    func loadImages() {
        if let urls = self.imgUrlsArr {
            var i: Int = 0
            for url in urls {
                if let url = NSURL(string: url) {
                    getDataFromUrl(url, index: i) { data, index in
                        if let data = NSData(contentsOfURL: url) {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.imagesArray[index] = UIImage(data: data)
                                if let collectionView = self.imagesCollectionView {
                                    collectionView.reloadItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
                                }
                            }
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

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgUrlsArr.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell: ImagesCollectionViewCell = self.imagesCollectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! ImagesCollectionViewCell
        cell.image = imagesArray[indexPath.row]
        cell.updateCell()
        return cell;
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.imagesCollectionView.frame.size
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
