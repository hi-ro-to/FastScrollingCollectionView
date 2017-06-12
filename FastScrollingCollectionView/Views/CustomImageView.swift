//
//  CustomImageView.swift
//  FastScrollingCollectionView
//
//  Created by Hiroto Ichinose on 2017/06/07.
//  Copyright © 2017年 hi-ro-to. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    func popinAnimation(_ sender: AnyObject){
        transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform.identity
        }
    }
}
