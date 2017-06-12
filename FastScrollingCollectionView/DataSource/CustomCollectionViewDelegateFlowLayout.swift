//
//  CustomCollectionViewDelegateFlowLayout.swift
//  FastScrollingCollectionView
//
//  Created by Hiroto Ichinose on 2017/06/07.
//  Copyright © 2017年 hi-ro-to. All rights reserved.
//

import UIKit

extension TunedCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == celebPhotoManager.getCount() - 1 {
            loadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let imageLoadOperation = imageLoadOperations?[indexPath] else {
            return
        }
        imageLoadOperation.cancel()
        _ = imageLoadOperations?.removeValue(forKey: indexPath)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // We should make sure to correctly refresh the collection view layout when transitioning to a different Size Class or rotating the device.
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] context in

            guard let strongSelf = self else { return }
            strongSelf.collectionView?.collectionViewLayout.invalidateLayout()

            }, completion: nil)
    }
}
