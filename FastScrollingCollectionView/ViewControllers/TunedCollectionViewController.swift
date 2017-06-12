//
//  TunedCollectionViewController.swift
//  FastScrollingCollectionView
//
//  Created by Hiroto Ichinose on 2017/06/06.
//  Copyright © 2017年 HirotoIchinose. All rights reserved.
//

import UIKit

class TunedCollectionViewController: UIViewController {
    fileprivate var refreshControl: UIRefreshControl!
    let reuseIdentifier = "customCell"
    var celebPhotoManager = CelebPhotoManager()
    
    // prefetch queue
    var imageLoadQueue: OperationQueue?
    var imageLoadOperations: [IndexPath: ImageLoadOperation]?
    
    // use integer not for cell or subviews to do anti-aliasing
    let cellWidth = Int(UIScreen.main.bounds.width / 2)
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // refresh controll
        setupRefreshControl()

        // load first photo list
        celebPhotoManager.loadCelebsPhotos()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // setup collection view
        self.navigationController?.hidesBarsOnSwipe = true
        self.collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false

        if #available(iOS 10.0, *) {
            collectionView?.prefetchDataSource = self
            imageLoadQueue = OperationQueue()
            imageLoadOperations = [IndexPath: ImageLoadOperation]()
        }
    }
    
    func loadMore() {
        celebPhotoManager.loadCelebsPhotos { [weak self] range in
            guard let strongSelf = self else { return }
            
            let indexPaths = (range).map { return IndexPath(row: $0, section: 0) }

            // update cells in main thread
            DispatchQueue.main.async {
                strongSelf.collectionView?.performBatchUpdates({ () -> Void in
                    strongSelf.collectionView?.insertItems(at: indexPaths)
                }, completion: nil)
            }
        }
    }
}

// MARK: - RefreshControll

extension TunedCollectionViewController {
    func setupRefreshControl() {
        collectionView?.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refreshControl)
    }
    
    func refresh() {
        // Call when only refresh is needness.
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }

        if #available(iOS 10.0, *) {
            imageLoadOperations?.forEach { $1.cancel() }
        }
        celebPhotoManager.reset()
        collectionView?.reloadData()
    }
}
