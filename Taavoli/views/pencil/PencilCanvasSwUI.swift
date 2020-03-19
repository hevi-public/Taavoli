//
//  PencilCanvas.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import Foundation
import SwiftUI

struct PencilCanvas: View {
    
    @Binding var drawingEntity: DrawingEntity
    
    @Environment var environment: EnvironmentObject
    
    var body: some View {
        PKCanvasUIKit(drawingEntity: $drawingEntity, environment: _environment)
    }
}

struct PKCanvasUIKit : UIViewRepresentable {
    
    @Binding var drawingEntity: DrawingEntity
    
    @Environment var environment: EnvironmentObject
    
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
