//
//  SpotViewController.swift
//  RivneFish
//
//  Created by akyryl on 06/09/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import UIKit

class SpotViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imagesCollectionView: UICollectionView!

    var imagesArray: Array<UIImage>!
    var currentIndex: Int
    let kCellIdentifier = "cellIdentifier"

    required init(coder aDecoder: NSCoder) {
        imagesArray = Array<UIImage>()
        currentIndex = 0

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        setupImagesCollectionView()
    }

    // UICollectionView methods
    func setupImagesCollectionView() {
        self.imagesCollectionView.registerNib(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)

        var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
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
        return imagesArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell: ImagesCollectionViewCell = self.imagesCollectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! ImagesCollectionViewCell
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
        var currentSize = self.imagesCollectionView.frame.size
        var offset = CGFloat(self.currentIndex) * self.imagesCollectionView.frame.size.width
        self.imagesCollectionView.contentOffset = CGPoint(x: offset, y: 0)

        UIView.animateWithDuration(0.15, animations: ({self.imagesCollectionView.alpha = 1.0}))
    }

    // TODO: Add asynchrolous images loading

    // Create a function to get the data from your url

    /*func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
        completion(data: data)
        }.resume()
    }

    // Create a function to start the tasks

    func downloadImage(url:NSURL){
        println("Started downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
        getDataFromUrl(url) { data in
        dispatch_async(dispatch_get_main_queue()) {
        println("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
        imageURL.image = UIImage(data: data!)
        }
        }
    }

    //Usage:

    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            println("Begin of code")
            imageURL.contentMode = UIViewContentMode.ScaleAspectFit
            if let checkedUrl = NSURL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
            downloadImage(checkedUrl)
            }
            println("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
    }
    */
}
