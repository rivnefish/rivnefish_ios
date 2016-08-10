//
//  PlaceImagesCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 09/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class PlaceImagesCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let kImageAspectRatioIndex: CGFloat = 1.33333
    let kMaxImagesCollectionViewHeight: CGFloat = CGFloat(768.0) / 1.33333

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    let kCellIdentifier = "imagesCellIdentifier"

    var imgUrlsArr: Array<String>!
    var imagesArray: Array<UIImage?>!
    var ourDataSource: DataSource?

    @IBOutlet weak var imagesCollectionView: UICollectionView! {
        didSet {
            imagesCollectionView.dataSource = self
            imagesCollectionView.delegate = self
        }
    }

    func setup(withUrlsArray urlsArray: Array<String>, dataSource: DataSource?) {
        imgUrlsArr = urlsArray
        imagesArray = Array<UIImage?>(count: urlsArray.count, repeatedValue: UIImage())
        self.ourDataSource = dataSource
        
        setupImagesCollectionView()
        loadImages()

        // TODO: move to somewhere like viewDidLoad
        heightConstraint?.constant = imagesViewHeight()
    }

    func imagesViewHeight() -> CGFloat {
        let height: CGFloat = self.imagesCollectionView.frame.width / kImageAspectRatioIndex

        var maxImagesViewPossibleHeight: CGFloat = 450
        /*if let navBarHeight = self.navigationController?.navigationBar.frame.height {
            maxImagesViewPossibleHeight = UIScreen.mainScreen().bounds.height - (navBarHeight + self.fishCollectionView.frame.height + fishViewTopMarginConstraint.constant)
        }*/
        let max = maxImagesViewPossibleHeight < kMaxImagesCollectionViewHeight ? maxImagesViewPossibleHeight : kMaxImagesCollectionViewHeight
        return height <= max ? height : max
    }

    private func loadImages() {
        imagesArray = [UIImage?](count: imgUrlsArr.count, repeatedValue: nil)

        // Make images collection view to know images count (cells count) before updating each cell by index
        dispatch_async(dispatch_get_main_queue(),{
            self.imagesCollectionView.reloadData()
        })

        // TODO: implement
        //if false == ActualityValidator.actualityValidator.markerUpToDate(marker) {
        //    ourDataSource.removeMarkerCachedImages(marker)
       // }

        // Load images and update collection view
        ourDataSource?.loadImages(self.imgUrlsArr) { (url: String, image:UIImage?) in
            dispatch_async(dispatch_get_main_queue()) {
                if let index = self.imgUrlsArr.indexOf(url) {
                    self.imagesArray[index] = image
                    if let collectionView = self.imagesCollectionView {
                        collectionView.reloadItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
                    }
                }
            }
        }
        //dispatch_async(dispatch_get_main_queue(),{
        //    self.updateContent()
        //    self.updateFishingInfoView()
        //})
    }

    private func setupImagesCollectionView() {
        self.imagesCollectionView.registerNib(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)

        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0

        self.imagesCollectionView.collectionViewLayout = flowLayout;
        self.imagesCollectionView.pagingEnabled = true
    }

    internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if let arr = imgUrlsArr {
            count = arr.count
        }
        return count
    }

    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        let cell: ImagesCollectionViewCell = self.imagesCollectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! ImagesCollectionViewCell
        cell.image = imagesArray[indexPath.row]
        cell.updateCell()
        collectionViewCell = cell;
        return collectionViewCell
    }

    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.imagesCollectionView.frame.size
    }
}
