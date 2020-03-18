//
//  PencilCanvas.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import Foundation
import SwiftUI

struct PencilCanvas: View {
    
    @EnvironmentObject var environment: Environment
    
    var body: some View {
        PKCanvasUIKit()
    }
}

struct PKCanvasUIKit : UIViewRepresentable {
    
    @EnvironmentObject var environment: Environment
    
    func makeUIView(context: Context) -> CanvasViewImpl {
        
        let canvas = CanvasViewImpl()
        if let window = environment.window {
            canvas.setup(window: window)
        }
        return canvas
    }
    
    func updateUIView(_ uiView: CanvasViewImpl, context: Context) {
        
    }
}
