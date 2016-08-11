//
//  FishImagesCell.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 10/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

class FishImagesCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    let kCellIdentifier = "imagesCellIdentifier"
    let kFishCellIdentifier = "fishImagesCellIdentifier"
    static let kFishCellWidth: CGFloat = 70.0

    @IBOutlet weak var imagesCollectionView: UICollectionView! {
        didSet {
            imagesCollectionView.dataSource = self
            imagesCollectionView.delegate = self
        }
    }

    var fishArray: Array<Fish>?
    var imagesArray: Array<UIImage?>!

    func setup(withFishArray fishArray: Array<Fish>) {
        self.fishArray = fishArray
        setupFishCollectionView()
    }

    func setupFishCollectionView() {
        self.imagesCollectionView.registerNib(UINib(nibName: "FishCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kFishCellIdentifier)

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
        return fishArray?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell: FishCollectionViewCell = self.imagesCollectionView.dequeueReusableCellWithReuseIdentifier(kFishCellIdentifier, forIndexPath: indexPath) as? FishCollectionViewCell,
            let fish = fishArray?[indexPath.row] {
            cell.image = fish.image
            cell.name = fish.ukrName
            if let amount = fish.amount {
                cell.amount = amount
            }
            cell.updateCell()
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: FishImagesCell.kFishCellWidth, height: self.imagesCollectionView.frame.height)
    }
}
