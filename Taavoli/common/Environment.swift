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
    
    public func update() {
        //        self.drawings = ManagedObjectContext.getAllEntity(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)])
        
        let url = URL(string: "http://Hevi-MacBook-Pro.local:8080/drawing")!
        var request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [[String: Any]] {
                
                var converted: [DrawingRequest] = []
                responseJSON.forEach { response in
                    guard let id = response["id"] as? String else { return }
                    guard let title = response["title"] as? String else { return }
                    guard let dataString = response["data"] as? String else { return }
                    guard let data = Data(base64Encoded: dataString) else { return }
                    
                    let drawing = DrawingRequest(objectId: id, title: title, data: data)
                    converted.append(drawing)
                }
                
                DispatchQueue.main.async {
                    self.drawings = converted
                }
                
                
                print("ResponseJSON: " + responseJSON.description)
            }
        }
        
        task.resume()
    }
}
