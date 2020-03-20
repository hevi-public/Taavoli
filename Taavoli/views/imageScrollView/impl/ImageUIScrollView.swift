//
//  GraphScrollView.swift
//  ForceDirectedNew
//
//  Created by Hevi on 14/03/2020.
//  Copyright © 2020 Hevi. All rights reserved.
//

import Foundation
import UIKit

class ImageUIScrollView: UIScrollView {
    
    var imageView: ImageView? {
        didSet {
            guard let size = imageView?.image?.size else { return }
            self.contentSize = CGSize(width: size.width, height: size.height)
            self.contentOffset = CGPoint(x: size.width / 2, y: size.height / 2)
        }
    }
    
    func display(_ imageView: ImageView) {
        
        self.imageView?.removeFromSuperview()
        self.imageView = nil
        
        self.imageView = imageView
        self.addSubview(imageView)
        
    }
    
    func setup() {
        
        self.delegate = self
        self.zoomScale = 1
        
//        self.contentSize = CGSize(width: 5000, height: 5000)
//        self.contentOffset = CGPoint(x: 2500, y: 2500)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
//        self.setMaxMinZoomScaleForCurrentBounds()
        self.centerImage()

        
    }
    
    private func centerImage() {
        guard var frameToCenter = imageView?.frame else { return }
        let boundsSize = self.bounds.size
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width)/2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height)/2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView?.frame = frameToCenter
    }
    
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            self.scrollRectToVisible(CGRect(x: childStartPoint.x, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
        }
    }

    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}

extension ImageUIScrollView: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.imageView
//    }
//
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        self.centerImage()
//    }
//
//    func setMaxMinZoomScaleForCurrentBounds() {
//        guard let imageSize = self.imageView?.bounds.size else { return }
//        let boundsSize = self.bounds.size
//
//        let xScale =  boundsSize.width  / imageSize.width
//        let yScale = boundsSize.height / imageSize.height
//        let minScale = min(xScale, yScale)
//
////        var maxScale: CGFloat = 5.0
////        if minScale < 0.1 {
////            maxScale = 0.3
////        }
////        if minScale >= 0.1 && minScale < 0.5 {
////            maxScale = 0.7
////        }
////        if minScale >= 0.5 {
////            maxScale = max(1.0, minScale)
////        }
////
//        self.maximumZoomScale = 6
//        self.minimumZoomScale = minScale
//    }
}
