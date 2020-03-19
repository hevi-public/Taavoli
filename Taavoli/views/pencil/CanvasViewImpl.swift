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

class CanvasViewImpl: PKCanvasView {
    
    private var timer: Timer! = nil
    
    private var drawingEntity: DrawingEntity!
    
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
        
        // TODO: cancel timer when not needed
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            
            self.drawingEntity.data = self.drawing.dataRepresentation()
            ManagedObjectContext.update()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setup(window: UIWindow, drawingEntity: DrawingEntity) {
        self.drawingEntity = drawingEntity
        
        do {
            if let data = drawingEntity.data {
                self.drawing = try PKDrawing(data: data)
            } else {
                self.drawing = PKDrawing()
            }
        } catch {
            print("Error converting data to Drawing")
        }
        
        #if !targetEnvironment(macCatalyst)
        guard let toolPicker = PKToolPicker.shared(for: window) else { return }
        toolPicker.setVisible(true, forFirstResponder: self)
        toolPicker.addObserver(self)
        
        _ = self.becomeFirstResponder()
        #endif
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
}
