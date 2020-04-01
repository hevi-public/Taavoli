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
import Starscream

class CanvasViewImpl: PKCanvasView, PKCanvasViewDelegate {
    
    let isCommunicationThroughWebSocket = true
    let webSocketUrl = URL(string: "ws://Hevi-MacBook-Pro.local:8080/ws/drawing")!
    var webSocket: WebSocket!
    
    private var drawingModel: DrawingModel!
    
    private var updateTimer: Timer! = nil
    private var lockUpdatingCanvasTimer: Timer?
    
    private var lockUpdates: Bool = false
    
    private var cancellables: [Cancellable] = []
    
    private var _delegate: CanvasViewDelegate!
    var isEditing: Bool = false
    
    fileprivate var justReceivedData: Bool = false
    
    private var state: TransmissionState = .none
    private var chunks: [DrawingRequest] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self._delegate = CanvasViewDelegate(self)
        self.delegate = self._delegate
        
        let height = 50000
        let width = 50000
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
        
        let request = URLRequest(url: webSocketUrl)
        webSocket = WebSocket(request: request)
        webSocket.delegate = self
        webSocket.connect()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update() {
        
        DrawingHttpStore().update(id: drawingModel.objectId, title: drawingModel.title, data: drawing.dataRepresentation(), completion: {})
        
//        do {
//            let sendChunks = chunkData(data: self.drawing.dataRepresentation())
//            webSocket.write(string: "transmission_start")
//
//            var i = 0
//            try sendChunks.forEach { (chunk) in
//                let drawingRequest = DrawingRequest(index: i, title: "title1", data: chunk)
//                let encoder = JSONEncoder()
//                let jsonData = try encoder.encode(drawingRequest)
//                webSocket.write(data: jsonData)
//                i = i + 1
//            }
//            webSocket.write(string: "transmission_end")
//
//        } catch {
//            print(error)
//        }
    }
    
    
    private func chunkData(data: Data) -> [Data] {
        let dataLen = data.count
        //        let chunkSize = ((1024 * 1000) * 4) // MB
        let chunkSize = 12000
        let fullChunks = Int(dataLen / chunkSize)
        let totalChunks = fullChunks + (dataLen % 12000 != 0 ? 1 : 0)
        
        var chunks: [Data] = [Data]()
        for chunkCounter in 0..<totalChunks {
            var chunk:Data
            let chunkBase = chunkCounter * chunkSize
            var diff = chunkSize
            if(chunkCounter == totalChunks - 1) {
                diff = dataLen - chunkBase
            }
            
            let range:Range = chunkBase..<(chunkBase + diff)
            chunk = data.subdata(in: range)
            chunks.append(chunk)
            print("The size is \(chunk.count)")
        }
        return chunks
    }
    
    public func setup(window: UIWindow, drawingModel: DrawingModel) {
        self.drawingModel = drawingModel
        
//        self.drawing = self.convertToDrawing(drawingModel: drawingModel)
        
        #if !targetEnvironment(macCatalyst)
        guard let toolPicker = PKToolPicker.shared(for: window) else { return }
        toolPicker.setVisible(true, forFirstResponder: self)
        toolPicker.addObserver(self)
        
        _ = self.becomeFirstResponder()
        #endif
    }
    
    override public func becomeFirstResponder() -> Bool {
        
        if let objectId = drawingModel.objectId {
            DrawingHttpStore().get(id: objectId, completion: { drawingRequest in
                do {
                    self.drawing = try PKDrawing(data: drawingRequest.data)
                } catch {
                    print(error)
                }
            })
        }
        
        
        
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
    
    
//    public static func getEntity(context: NSManagedObjectContext) -> DrawingEntity? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Drawing")
//        do {
//            return try context.fetch(fetchRequest).first as? DrawingEntity
//        } catch let error {
//            print(error.localizedDescription)
//        }
//        return nil
//    }
    
    private func convertToDrawing(drawingModel: DrawingModel) -> PKDrawing {
        do {
            let data = drawingModel.data
            return try PKDrawing(data: data)
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
        if !self.canvasView.justReceivedData {
            canvasView.update()
        }
        self.canvasView.justReceivedData = false
    }
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        
    }
    
}


extension CanvasViewImpl: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            //            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            //            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            
            switch string {
            case "transmission_start":
                self.state = .transmission
            case "transmission_end":
                self.state = .transmissionEnded
            default:
                self.state = .none
            }
            
            
            
            if self.state == .transmissionEnded {
                
                let sorted = self.chunks.sorted { (r1, r2) -> Bool in
                    r1.index < r2.index
                }
                
                let mappedToData = sorted.map { (drawingRequest) -> Data in
                    drawingRequest.data
                }
                
                var finalData = Data()
                mappedToData.forEach { (chunk) in
                    finalData.append(chunk)
                }
                
                do {
                    
                    let drawing = try PKDrawing(data: finalData)
                    self.drawing = drawing
                    
                } catch {
                    print("Error converting to PKDrawing: " + error.localizedDescription)
                }
                self.chunks = []
                self.state = .none
            }
            
            webSocket.write(ping: Data())
            
            
            
            
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
            
            self.justReceivedData = true
            let decoder = JSONDecoder()
            
            do {
                let drawingRequest = try decoder.decode(DrawingRequest.self, from: data)
                self.chunks.append(drawingRequest)
            } catch {
                print(error)
            }
            
            
            //                let image = drawing.image(from: drawing.bounds, scale: 1.0)
            //                self.display(image)
            
            
        case .ping(_):
            break
        case .pong(_):
            break
        case .viablityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            //            isConnected = false
            break
        case .error(let error):
            //            isConnected = false
            //            handleError(error)
            break
        }
        
        
        
    }
}

enum TransmissionState {
    case none
    case transmission
    case transmissionEnded
}
