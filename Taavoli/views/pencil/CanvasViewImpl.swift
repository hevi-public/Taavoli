//
//  CanvasViewImpl.swift
//  hu.hevi.node.ios
//
//  Created by Hevi on 09/11/2019.
//  Copyright © 2019 Hevi. All rights reserved.
//

import Foundation
import PencilKit
import CoreData
import Combine

class CanvasViewImpl: PKCanvasView {
    
    
    
    private var drawingEntity: DrawingEntity!
    
    private var updateTimer: Timer! = nil
    private var lockUpdatingCanvasTimer: Timer?
    
    private var lockUpdates: Bool = false
    
    private var cancellables: [Cancellable] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.delegate = self
        
        let height = 500000
        let width = 500000
        self.contentSize = CGSize(width: width, height: height)
        
        let centerContentOffsetX = (self.contentSize.width / 2) - (self.bounds.size.width / 2)
        let centerContentOffsetY = (self.contentSize.height / 2) - (self.bounds.size.height / 2)
        self.contentOffset = CGPoint(x: centerContentOffsetX, y: centerContentOffsetY)
        
        self.maximumZoomScale = 5
        self.minimumZoomScale = 0.005
        self.zoomScale = 0.2
        
        #if !targetEnvironment(macCatalyst)
        self.allowsFingerDrawing = false
        #endif
        
        // TODO: cancel timer when not needed
        self.updateTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in

//            if !self.lockUpdates {
//                self.drawing = self.convertToDrawing(drawingEntity: self.drawingEntity)
//            } else {
                self.drawingEntity.data = self.drawing.dataRepresentation()
                ManagedObjectContext.update()
//            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setup(window: UIWindow, drawingEntity: DrawingEntity) {
        self.drawingEntity = drawingEntity
        
        self.drawing = self.convertToDrawing(drawingEntity: drawingEntity)
        
        #if !targetEnvironment(macCatalyst)
        guard let toolPicker = PKToolPicker.shared(for: window) else { return }
        toolPicker.setVisible(true, forFirstResponder: self)
        toolPicker.addObserver(self)
        
        _ = self.becomeFirstResponder()
        #endif
        
        self.cancellables.append(
            NotificationCenter.Publisher(center: .default, name: .cloudUpdated).sink { notification in
                
                let newObject = ManagedObjectContext.get(id: self.drawingEntity.objectID)
                self.drawingEntity = newObject
                self.drawing = self.convertToDrawing(drawingEntity: drawingEntity)
            }
        )
    }
    
    override public func becomeFirstResponder() -> Bool {
        
        //        if self.drawingEntity == nil {
        //            let drawingEntity = NodeRepository.save(drawing: self.drawing.dataRepresentation())
        //            self.entity.drawing = drawingEntity
        //
        //        }
        //
        //        self.drawingEntity?.data = self.drawing.dataRepresentation()
        //
        //
        //        _ = NodeRepository.update()
        //
        return super.becomeFirstResponder()
    }
    
    
    public static func getEntity(context: NSManagedObjectContext) -> DrawingEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Drawing")
        do {
            return try context.fetch(fetchRequest).first as? DrawingEntity
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func convertToDrawing(drawingEntity: DrawingEntity) -> PKDrawing {
        do {
            if let data = drawingEntity.data {
                return try PKDrawing(data: data)
            }
        } catch {
            print("Error converting data to Drawing")
        }
        return PKDrawing()
    }
}

extension CanvasViewImpl: PKCanvasViewDelegate {
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        
    }
    
}
