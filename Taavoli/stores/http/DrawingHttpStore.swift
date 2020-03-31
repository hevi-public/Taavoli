//
//  DrawingHttpClient.swift
//  Taavoli
//
//  Created by Hevi on 31/03/2020.
//

import Foundation

public class DrawingHttpStore {
    
    let postEndPoint = "http://Hevi-MacBook-Pro.local:8080/drawing"
    
    func update(title: String, data: Data) {
        do {
            let url = URL(string: postEndPoint)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let json = DrawingRequest(title: title, data: data)
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(json)
            
            request.httpBody = jsonData
            
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
    
    public func getAll(completion: @escaping ([DrawingRequest]) -> () = {_ in }) {
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
                    completion(converted)
                }
                
                
                print("ResponseJSON: " + responseJSON.description)
            }
        }
        
        task.resume()
    }
}