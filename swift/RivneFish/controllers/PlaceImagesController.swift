//
//  PlaceImagesController.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 29/04/2017.
//  Copyright © 2017 rivnefish. All rights reserved.
//

import SKPhotoBrowser

class PlaceImagesController: UIViewController {
    let kCellIdentifier = "ImageViewCell"

    var imgUrlsArr: Array<String>?
    fileprivate var imagesArray: Array<UIImage?>?
    var dataSource: DataSource?

    var skBrowser = SKPhotoBrowser(photos: [])

    static var currentImageIndex: Int = 0

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
        }
        imagesCollectionView?.reloadData()
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

        self.imagesCollectionView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)

        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
    }
}

extension PlaceImagesController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageViewCell else { return }

        launchSKBrowser(indexPath: indexPath, cell: cell)
    }

    private func launchSKBrowser(indexPath: IndexPath, cell: ImageViewCell) {
        guard let images: Array<UIImage> = imagesArray?.flatMap({ $0 }) else { return }

        var idx = 0
        if let image = imagesArray?[indexPath.row] {
            idx = index(of: image, in: images) ?? 0
        }

        let skImages: Array<SKPhotoProtocol> = images.map({ SKPhoto.photoWithImage($0) })
        let browser = SKPhotoBrowser(photos: skImages)
        browser.initializePageIndex(idx)
        present(browser, animated: true, completion: {})
    }

    private func index(of image: UIImage, in images: Array<UIImage>) -> Int? {
        var index: Int? = nil
        var i = 0
        for img in images {
            if img.isEqual(image) {
                index = i
            }
            i += 1
        }
        return index
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: UIScreen.main.bounds.size.width / 2 - 5, height: 300)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width / 2 - 5, height: 200)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgUrlsArr?.count ?? 0
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as? ImageViewCell else {
            return UICollectionViewCell()
        }
        if let image = imagesArray?[indexPath.row] {
            cell.updateCell(withImage: image)
        }
        return cell
    }
}

/*extension PlaceImagesController: SKPhotoBrowserDelegate {
    func didShowPhotoAtIndex(_ index: Int) {
        imagesCollectionView.visibleCells.forEach({$0.isHidden = false})
        imagesCollectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = true
    }

    func willDismissAtPageIndex(_ index: Int) {
        imagesCollectionView.visibleCells.forEach({$0.isHidden = false})
        imagesCollectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = true
    }

    func willShowActionSheet(_ photoIndex: Int) {
        // do some handle if you need
    }

    func didDismissAtPageIndex(_ index: Int) {
        imagesCollectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = false
    }

    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
        // handle dismissing custom actions
    }

    func removePhoto(index: Int, reload: (() -> Void)) {
        reload()
    }

    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        return imagesCollectionView.cellForItem(at: IndexPath(item: index, section: 0))
    }
}
*/
