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
            imagesArray = Array<UIImage?>(repeating: nil, count: urlsArray.count)
            self.dataSource = dataSource
            loadImagesIfNeeded()
            let urlsCount = urlsArray.count
            viewPageControl?.numberOfPages = kMaxPageCount < urlsCount ? kMaxPageCount : urlsCount
            viewPageControl?.currentPage = 0
        }
        correctCollectionViewOffset()
        imagesCollectionView.reloadData()
    }

    fileprivate func correctCollectionViewOffset() {
        let offset = CGFloat(currentImageIndex) * imagesCollectionView.frame.size.width
        imagesCollectionView.contentOffset = CGPoint(x: offset, y: 0)
    }

    fileprivate func loadImagesIfNeeded() {
        if imagesArray == nil {
            imagesArray = [UIImage?](repeating: nil, count: imgUrlsArr?.count ?? 0)
        }

        // Load images and update collection view
        dataSource?.loadImages(self.imgUrlsArr) { (url: String, image:UIImage?) in
            if let index = self.imgUrlsArr?.index(of: url) {
                self.imagesArray?[index] = image
                if let collectionView = self.imagesCollectionView {
                    collectionView.reloadItems(at: [IndexPath.init(item: index, section: 0)])
                }
            }
        }
    }

    func setupImagesCollectionView() {
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self

        self.imagesCollectionView.register(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)

        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0

        imagesCollectionView.collectionViewLayout.invalidateLayout()
        imagesCollectionView.collectionViewLayout = flowLayout
        imagesCollectionView.isPagingEnabled = true
    }

    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgUrlsArr?.count ?? 0
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        if let cell: ImagesCollectionViewCell = self.imagesCollectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as? ImagesCollectionViewCell {
            cell.updateCell(withImage: imagesArray?[(indexPath as NSIndexPath).row])
            collectionViewCell = cell;
        }
        return collectionViewCell
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.imagesCollectionView.frame.size
    }

    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentImageIndex = Int(imagesCollectionView.contentOffset.x / imagesCollectionView.frame.size.width)
        updatePageCountrol()
    }

    fileprivate func updatePageCountrol() {
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
