//
//  PlaceImagesCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 09/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class PlaceImagesCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let kCellIdentifier = "imagesCellIdentifier"
    let kMaxPageCount = 10

    var imgUrlsArr: Array<String>?
    var imagesArray: Array<UIImage?>?
    var dataSource: DataSource?

    var currentImageIndex = 0

    @IBOutlet weak var viewPageControl: UIPageControl!
    @IBOutlet weak var imagesCollectionView: UICollectionView! {
        didSet {
            setupImagesCollectionView()
        }
    }

    func setup(withUrlsArray urlsArray: Array<String>, dataSource: DataSource?) {
        if imgUrlsArr == nil || imagesArray == nil {
            imgUrlsArr = urlsArray
            imagesArray = Array<UIImage?>(count: urlsArray.count, repeatedValue: nil)
            self.dataSource = dataSource
            loadImagesIfNeeded()
            let urlsCount = urlsArray.count
            viewPageControl?.numberOfPages = kMaxPageCount < urlsCount ? kMaxPageCount : urlsCount
            viewPageControl?.currentPage = 0
        }
        correctCollectionViewOffset()
        imagesCollectionView.reloadData()
    }

    private func correctCollectionViewOffset() {
        let offset = CGFloat(currentImageIndex) * imagesCollectionView.frame.size.width
        imagesCollectionView.contentOffset = CGPoint(x: offset, y: 0)
    }

    private func loadImagesIfNeeded() {
        if imagesArray == nil {
            imagesArray = [UIImage?](count: imgUrlsArr?.count ?? 0, repeatedValue: nil)
        }

        // Load images and update collection view
        dataSource?.loadImages(self.imgUrlsArr) { (url: String, image:UIImage?) in
            if let index = self.imgUrlsArr?.indexOf(url) {
                self.imagesArray?[index] = image
                if let collectionView = self.imagesCollectionView {
                    collectionView.reloadItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
                }
            }
        }
    }

    func setupImagesCollectionView() {
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self

        self.imagesCollectionView.registerNib(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)

        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0

        imagesCollectionView.collectionViewLayout.invalidateLayout()
        imagesCollectionView.collectionViewLayout = flowLayout
        imagesCollectionView.pagingEnabled = true
    }

    internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgUrlsArr?.count ?? 0
    }

    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        if let cell: ImagesCollectionViewCell = self.imagesCollectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as? ImagesCollectionViewCell {
            cell.updateCell(withImage: imagesArray?[indexPath.row])
            collectionViewCell = cell;
        }
        return collectionViewCell
    }

    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.imagesCollectionView.frame.size
    }

    internal func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentImageIndex = Int(imagesCollectionView.contentOffset.x / imagesCollectionView.frame.size.width)
        updatePageCountrol()
    }

    private func updatePageCountrol() {
        guard let imagesCount = imgUrlsArr?.count else { return }

        var currentIndex: Int
        if imagesCount <= kMaxPageCount {
            currentIndex = currentImageIndex
        } else {
            let index = imagesCount / kMaxPageCount
            currentIndex = currentImageIndex / index
        }
        viewPageControl?.currentPage = currentIndex
    }
}
