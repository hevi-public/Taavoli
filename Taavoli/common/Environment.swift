//
//  Environment.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import Foundation
import Combine
import UIKit

class AppEnvironment: ObservableObject {
    var window: UIWindow?
    
    @Published var drawings: [DrawingModel] = []
    
    init() {
        self.update()
    }
    
    public func update(completion: @escaping ([DrawingRequest]) -> () = {_ in }) {
//        self.drawings = CoreDataStore().getAll()
        
        DrawingHttpStore().getAll { (drawingRequests) in
            self.drawings = drawingRequests.map { drawingRequest -> DrawingModel in
                return DrawingModel(objectId: drawingRequest.id, index: drawingRequest.index, title: drawingRequest.title, data: drawingRequest.data)
            }
        }
        
    }
}
