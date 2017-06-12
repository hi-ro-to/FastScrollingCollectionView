//
//  CelebPhotoManager.swift
//  FastScrollingCollectionView
//
//  Created by Hiroto Ichinose on 2017/06/07.
//  Copyright © 2017年 hi-ro-to. All rights reserved.
//

import UIKit

class CelebPhotoManager {
    private var photoUrlList = [URL]()
    private var page = 1
    private let limit = 10
    
    static let shared = CelebPhotoManager()
    
    func getCount() -> Int {
        return photoUrlList.count
    }

    func loadCelebsPhotos(_ completion: ((CountableRange<Int>) -> Void)? = nil) {
        var (start, end) = ((page - 1) * limit, limit * page)

        guard CelebPhotoUrlList.urlList.count >= start else { return }
        
        if CelebPhotoUrlList.urlList.count < end {
            end = CelebPhotoUrlList.urlList.count
        }

        let range = start..<end
        CelebPhotoUrlList.urlList[range].forEach { urlStr in
            guard let url = URL(string: urlStr) else { return }

            photoUrlList.append(url)
        }
        page += 1

        completion?(range)
    }
    
    func getCelebPhotoUrl(atIndex index: Int) -> URL {
        return photoUrlList.count > index ? photoUrlList[index] : URL(fileURLWithPath: CelebPhotoUrlList.hazure)
    }
    
    func reset() {
        // reset the number of page
        page = 1
        // reset list
        photoUrlList.removeAll()
        // reload new data
        loadCelebsPhotos()
    }
}
