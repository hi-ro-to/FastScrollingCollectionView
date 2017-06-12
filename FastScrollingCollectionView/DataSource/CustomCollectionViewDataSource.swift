//
//  CustomCollectionViewDataSource.swift
//  FastScrollingCollectionView
//
//  Created by Hiroto Ichinose on 2017/06/07.
//  Copyright © 2017年 hi-ro-to. All rights reserved.
//

import UIKit

extension TunedCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return celebPhotoManager.getCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCell
        
        // Configure the cell
        let imgUrl = celebPhotoManager.getCelebPhotoUrl(atIndex: indexPath.item)
        cell.configure(imgUrl: imgUrl)
        
        return cell
    }
}
