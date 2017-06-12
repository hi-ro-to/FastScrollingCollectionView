//
//  CustomCollectionViewDataSourcePrefetching.swift
//  FastScrollingCollectionView
//
//  Created by Hiroto Ichinose on 2017/06/08.
//  Copyright © 2017年 hi-ro-to. All rights reserved.
//

import UIKit

extension TunedCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = imageLoadOperations?[indexPath] {
                return
            }
            
            let imgUrl = celebPhotoManager.getCelebPhotoUrl(atIndex: indexPath.item)
            let imageLoadOperation = ImageLoadOperation(imgUrl: imgUrl)
            imageLoadQueue?.addOperation(imageLoadOperation)
            imageLoadOperations?[indexPath] = imageLoadOperation
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let imageLoadOperation = imageLoadOperations?[indexPath] else {
                return
            }
            imageLoadOperation.cancel()
            _ = imageLoadOperations?.removeValue(forKey: indexPath)
        }
    }
}
