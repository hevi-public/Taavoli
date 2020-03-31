//
//  PencilCanvas.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import Foundation
import SwiftUI

struct PencilCanvas: View {
    
    var drawingModel: DrawingModel
    
    var body: some View {
        PKCanvasUIKit(drawingModel: drawingModel)
    }
}

struct PKCanvasUIKit : UIViewRepresentable {
    
    var drawingModel: DrawingModel
    
    @EnvironmentObject var environment: AppEnvironment
    
    func makeUIView(context: Context) -> CanvasViewImpl {
        
        let canvas = CanvasViewImpl()
        if let window = environment.window {
            canvas.setup(window: window, drawingModel: drawingModel)
        }
        return canvas
    }
    
    func updateUIView(_ uiView: CanvasViewImpl, context: Context) {
        
    }
}
