//
//  CanvasViewContainerView.swift
//  hu.hevi.node.ios
//
//  Created by Hevi on 09/11/2019.
//  Copyright © 2019 Hevi. All rights reserved.
//

import Foundation
import UIKit
import PencilKit

class CanvasViewContainerView: UIViewController {
    
    var canvasView: PKCanvasView!
    
    override func viewDidLoad() {
        
        canvasView = PKCanvasView(frame: .zero)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(canvasView)

        #if !targetEnvironment(macCatalyst)
        guard let window = self.view.window, let toolPicker = PKToolPicker.shared(for: window) else { return }
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        #endif
    }
}
