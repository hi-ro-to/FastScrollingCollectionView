# FasterPureCollectionView

UICollectionView with optimized smooth scrolling and improved performance. 

I expect that you use this when you want to add UICollectionView displaying images to your app.

# Tips
## 1. Cache image

We can use SDWebImage. Standing on the shoulders of giants.

## 2. Don’t Block the Main Thread

Our app will appear unresponsive if our code blocks the main thread.
We should connect to network and load image and some tasks in background thread.

This sample uses SDWebImage that load image asynchonously.

```
imageView.sd_setImage(with: url, placeholderImage: placeholder, options: .retryFailed, completed: { img, error, type, url in })
```

And resize or Add corner raidus or etc in Background.

```
DispatchQueue.global(qos: .background).async {
    imageView.layer.cornerRadius = self.frame.size.width / 2
    imageView.clipsToBounds = true
}
```

## 3. Prefetch Images (Only iOS 10 or above)

We can load ahead images if you use the following delegate method.
`func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {`

And use queue (`ImageLoadOperation`) to cancel loading images when the cell showing loaded image get out of screen because UICollectionViewCell is reused and loaded image is often shown on wrong cell.

## 4. Use Integer for cell size

It is easier for UICollectionView to calculate cell size.

## 5. Reuse objects

Initialization is slow, especially UIView.
We should avoid initializing as possible as we can.

Like this.

```
guard imageView == nil else { return }
```

## 6. Avoid heavy drawing processing

We expect processing reduction.

- Hide vertical/horizantol scroll indicator.
  - `self.collectionView?.showsVerticalScrollIndicator = false` or `self.collectionView?.showsHorizontalScrollIndicator = false
`
- Remove 'contentView' from UICollectionViewCell.
- Avoid gradients, image scaling, and offscreen drawing.
- Set Views as Opaque When Possible.
  - If we set Opaque to NO, the drawing system composites the view normally with other content.
- Cache the size of cells if they aren’t always the same.
- Load contents of cells in background.
- Reduce the number of subviews.
- Fix cell size after loading contents before display it.

## 7. Refresh only when not refreshing

We don't have to refresh every time you pull to refresh.

```
if refreshControl.isRefreshing {
   refreshControl.endRefreshing()
}
```

## 8. Make sure to refresh new layout

We should make sure to correctly refresh the collection view layout when transitioning to a different Size Class or rotating the device.

```
super.viewWillTransition(to: size, with: coordinator)
coordinator.animate(alongsideTransition: { [weak self] context in
   guard let strongSelf = self else { return }
   strongSelf.collectionView?.collectionViewLayout.invalidateLayout()
}, completion: nil)
```

## 9. Use fixed size for cell (Avoid using Self-Sizing Cells)

We expect processing reduction of Self-Sizing Cells if we use fixed size for cells.

```
override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    return layoutAttributes
}
```

## 10. Feedin for good user interface

We can make users feel fast if we add a little animation.

## 11. Simple pop-in animation for good user interaction

It is important that we offer user-interaction for good user experience.

# Other Tips
- Cache the size of cells if they aren’t always the same.
- Manage queue of loading data shown on cell
- Compress image file
- Draw images or buttons or view components
- Use the Correct Collection
- Arrays
  - Ordered collections. Access to their contents by index.the order matters.
  - [Apple Document](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Collections/Articles/Arrays.html#//apple_ref/doc/uid/20000132-BBCCJBIF)
- Dictionaries
  - Unordered collections. Pairs of keys and values. access to their contents by keyed-value.
  - fast insertion and deletion operations
  - [Apple Document](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Collections/Articles/Dictionaries.html#//apple_ref/doc/uid/20000134-CJBCBGII)
- Sets
  - Unordered collections. fast insertion and deletion operations. Quickly lookup.
  - [Apple Document](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Collections/Articles/Sets.html#//apple_ref/doc/uid/20000136-CJBDHAJD)
- We should use colorWithPatternImage for pattern Images
  - We should go with UIColor’s `colorWithPatternImage` when we show a patterned image which will be repeated or tiled to fill the background.
  - It’s faster to draw and won’t use a lot of memory in this case.
  

