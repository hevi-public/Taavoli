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

class CanvasViewImpl: PKCanvasView, PKCanvasViewDelegate {
    
    
    
    private var drawingEntity: DrawingEntity!
    
    private var updateTimer: Timer! = nil
    private var lockUpdatingCanvasTimer: Timer?
    
    private var lockUpdates: Bool = false
    
    private var cancellables: [Cancellable] = []
    
    private var _delegate: CanvasViewDelegate!
    var isEditing: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self._delegate = CanvasViewDelegate(self)
        self.delegate = self._delegate
        
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
        //        self.updateTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
        //
        ////            if !self.lockUpdates {
        ////                self.drawing = self.convertToDrawing(drawingEntity: self.drawingEntity)
        ////            } else {
        //            self.update()
        ////            }
        //        }
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update() {
        DispatchQueue.main.async {
            do {
                self.drawingEntity.data = self.drawing.dataRepresentation()
                self.drawingEntity.updatedAt = Date()
                ManagedObjectContext.update()
                
                let url = URL(string: "http://Hevi-MacBook-Pro.local:8080")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let json = DrawingRequest(title: "my title")
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(json)
                
                request.httpBody = jsonData
                
//                print(request.debugDescription)
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print("ResponseJSON: " + responseJSON.description)
                    }
                }
                
                task.resume()
            } catch {
                print(error)
            }
        }
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

class CanvasViewDelegate: NSObject, PKCanvasViewDelegate {
    
    private let canvasView: CanvasViewImpl
    
    init(_ canvasView: CanvasViewImpl) {
        self.canvasView = canvasView
    }
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        self.canvasView.isEditing = true
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        self.canvasView.isEditing = false
        
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        guard let canvasView = canvasView as? CanvasViewImpl else { return }
        canvasView.update()
    }
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        
    }
    
}

struct DrawingRequest: Codable {
    let id: Int?
    let title: String
    
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
