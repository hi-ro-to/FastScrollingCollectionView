//
//  ImageLoadOperation.swift
//  FastScrollingCollectionView
//
//  Created by Hiroto Ichinose on 2017/06/08.
//  Copyright © 2017年 hi-ro-to. All rights reserved.
//

import Foundation
import SDWebImage

class ImageLoadOperation: Operation {
    private var imgUrl: URL
    private var imagePrefeetcher = SDWebImagePrefetcher()
    var completionHandler: (() -> Void)?
    
    init(imgUrl: URL) {
        self.imgUrl = imgUrl
    }
    
    override func cancel() {
        imagePrefeetcher.cancelPrefetching()
        
        super.cancel()
    }

    override func main() {
        if isCancelled {
            return
        }

        imagePrefeetcher.prefetchURLs([imgUrl], progress: nil) { [weak self] _, _ in
            guard let strongSelf = self else { return }
            
            strongSelf.completionHandler?()
        }
    }
}
