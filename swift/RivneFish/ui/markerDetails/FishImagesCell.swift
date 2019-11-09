//
//  FishImagesCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 10/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class FishImagesCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    let kCellIdentifier = "imagesCellIdentifier"
    let kFishCellIdentifier = "fishImagesCellIdentifier"
    static let kFishCellWidth: CGFloat = 70.0
    var currentImageIndex = 0

    @IBOutlet weak var imagesCollectionView: UICollectionView! {
        didSet {
            setupFishCollectionView()
        }
    }

    var fishArray: Array<FishViewModel>?

    func reloadCell(at index: Int) {
        imagesCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }

    func setup(withFishArray fishArray: Array<FishViewModel>) {
        self.fishArray = fishArray

        correctCollectionViewOffset()
        imagesCollectionView.reloadData()
    }

    func setupFishCollectionView() {
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self

        self.imagesCollectionView.register(UINib(nibName: "FishCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kFishCellIdentifier)

        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0

        imagesCollectionView.collectionViewLayout.invalidateLayout()
        imagesCollectionView.collectionViewLayout = flowLayout
    }

    fileprivate func correctCollectionViewOffset() {
        let offset = CGFloat(currentImageIndex) * imagesCollectionView.frame.size.width
        imagesCollectionView.contentOffset = CGPoint(x: offset, y: 0)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fishArray?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: FishCollectionViewCell = self.imagesCollectionView.dequeueReusableCell(withReuseIdentifier: kFishCellIdentifier, for: indexPath) as? FishCollectionViewCell,
            let fish = fishArray?[(indexPath as NSIndexPath).row] {
            cell.image = fish.image
            cell.name = fish.name
            cell.amount = fish.amount
            cell.updateCell()
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FishImagesCell.kFishCellWidth, height: self.imagesCollectionView.frame.height)
    }

    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentImageIndex = Int(imagesCollectionView.contentOffset.x / imagesCollectionView.frame.size.width)
    }
}
