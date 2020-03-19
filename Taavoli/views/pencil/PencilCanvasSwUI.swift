//
//  PencilCanvas.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import Foundation
import SwiftUI

struct PencilCanvas: View {
    
    var drawingEntity: DrawingEntity
    
    var body: some View {
        PKCanvasUIKit(drawingEntity: drawingEntity)
    }
}

struct PKCanvasUIKit : UIViewRepresentable {
    
    var drawingEntity: DrawingEntity
    
    @EnvironmentObject var environment: AppEnvironment
    
    func makeUIView(context: Context) -> CanvasViewImpl {
        
        let canvas = CanvasViewImpl()
        if let window = environment.window {
            canvas.setup(window: window, drawingEntity: drawingEntity)
        }
        return canvas
    }
    
    func updateUIView(_ uiView: CanvasViewImpl, context: Context) {
        
    }
}
