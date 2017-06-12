//
//  CustomCell.swift
//  FastScrollingCollectionView
//
//  Created by Hiroto Ichinose on 2017/06/07.
//  Copyright © 2017年 hi-ro-to. All rights reserved.
//

import UIKit
import SDWebImage

class CustomCell: UICollectionViewCell {
    var imageView: CustomImageView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // remove 1 view
        contentView.removeFromSuperview()

        setupImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.image = nil
    }
    
    func configure(imgUrl: URL) {
        // animate feedin for good user interface
        imageView?.alpha = 0

        // cache
        let cacheKey = SDWebImageManager.shared().cacheKey(for: imgUrl)
        var cachedImg = SDWebImageManager.shared().imageCache.imageFromMemoryCache(forKey: cacheKey)
        if cachedImg == nil {
            cachedImg = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: cacheKey)
        }

        // add pop-in animation for good user interaction
        if let imageView = self.imageView {
            let tapGestureRecognizer = UITapGestureRecognizer(target: imageView, action: #selector(imageView.popinAnimation(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)

            // customize imageview in background
            DispatchQueue.global(qos: .background).async {
                imageView.layer.cornerRadius = self.frame.size.width / 2
                imageView.clipsToBounds = true
            }
            
            // use cache if it exists
            imageView.sd_setImage(with: imgUrl, placeholderImage: cachedImg, options: .retryFailed, completed: { img, error, type, url in
                UIView.animate(withDuration: 0.3) {
                    self.imageView?.alpha = 1
                }
            })
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // prevent auto resizing from cell
        return layoutAttributes
    }
}

extension CustomCell {
    fileprivate func setupImageView() {
        guard imageView == nil else { return }

        var cellFrame = self.frame
        cellFrame.origin.x = 0
        cellFrame.origin.y = 0

        imageView = CustomImageView(frame: cellFrame)

        // do not use transparent subview
        imageView!.isOpaque = true

        addSubview(imageView!)
    }
}
