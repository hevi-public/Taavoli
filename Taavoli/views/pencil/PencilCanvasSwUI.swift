//
//  PencilCanvas.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import Foundation
import SwiftUI

struct PencilCanvas: View {
    
    @State var allowFingerDrawing: Bool = false
    
    var drawingModel: DrawingModel
    
    var body: some View {
        ZStack {
            PKCanvasUIKit(allowsFingerDrawing: $allowFingerDrawing, drawingModel: drawingModel)
            
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button(action: {
                        self.allowFingerDrawing.toggle()
                    }, label: {
                        if self.allowFingerDrawing {
                            Image(systemName: "hand.draw")
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color.white)
                                .font(.system(size: 24, weight: .medium))
                        } else {
                            Image(systemName: "pencil.and.outline")
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color.white)
                                .font(.system(size: 24, weight: .medium))
                        }
                    })
                        .background(Color.blue)
                        .opacity(0.65)
                        .cornerRadius(40)
                        .padding()

                }
            }
        }
    }
}

struct PKCanvasUIKit : UIViewRepresentable {
    
    @Binding var allowsFingerDrawing: Bool
    
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
        uiView.allowsFingerDrawing = self.allowsFingerDrawing
    }
}
