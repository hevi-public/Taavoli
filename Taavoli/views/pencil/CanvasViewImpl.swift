//
//  CanvasViewImpl.swift
//  hu.hevi.node.ios
//
//  Created by Hevi on 09/11/2019.
//  Copyright © 2019 Hevi. All rights reserved.
//

import Foundation
import PencilKit

class CanvasViewImpl: PKCanvasView {
    
    private var timer: Timer! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let height = 5000
        let width = 5000
        self.contentSize = CGSize(width: width, height: height)
        
        let centerContentOffsetX = (self.contentSize.width / 2) - (self.bounds.size.width / 2)
        let centerContentOffsetY = (self.contentSize.height / 2) - (self.bounds.size.height / 2)
        self.contentOffset = CGPoint(x: centerContentOffsetX, y: centerContentOffsetY)
        
        self.maximumZoomScale = 5
        self.minimumZoomScale = 0.005
        self.zoomScale = 0.2
        
        #if !targetEnvironment(macCatalyst)
        self.allowsFingerDrawing = true
        #endif
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setup(window: UIWindow) {
        #if !targetEnvironment(macCatalyst)
        guard let toolPicker = PKToolPicker.shared(for: window) else { return }
        toolPicker.setVisible(true, forFirstResponder: self)
        toolPicker.addObserver(self)
        
        _ = self.becomeFirstResponder()
        #endif
    }
}
