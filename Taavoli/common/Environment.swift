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
    
    @Published var drawings: [DrawingRequest] = []
    
    init() {
        self.update()
    }
    
    public func update(completion: @escaping ([DrawingRequest]) -> () = {_ in }) {
        //        self.drawings = ManagedObjectContext.getAllEntity(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)])
        
        DrawingHttpStore().getAll { (drawingRequests) in
            self.drawings = drawingRequests
        }
        
    }
}
