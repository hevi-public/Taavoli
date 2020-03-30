//
//  PencilTab.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import SwiftUI
import CoreData
import PencilKit


struct PencilTab: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var environment: AppEnvironment
    
    //    @FetchRequest(entity: DrawingEntity.entity(), sortDescriptors: [], predicate: nil) var drawings: FetchedResults<DrawingEntity>
    
    var body: some View {
        NavigationView {
            List(environment.drawings) { drawingEntity in
                NavigationLink(destination: PencilCanvas(drawingEntity: drawingEntity)) {
                    Text(drawingEntity.updatedAt?.description ?? "")
                }
                
                
            }.navigationBarItems(trailing:
                Text("Add").onTapGesture {
                    do {
                        
                        let url = URL(string: "http://Hevi-MacBook-Pro.local:8080/drawing")!
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        
                        let json = DrawingRequest(title: "title2", data: PKDrawing().dataRepresentation())
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
                        
                        
                        
                        
                        
                        //                        guard let entity =  NSEntityDescription.entity(forEntityName: "DrawingEntity", in: self.managedObjectContext) else { return }
                        //                        let drawingEntity = DrawingEntity(entity: entity, insertInto: self.managedObjectContext)
                        //
                        //                        drawingEntity.createdAt = Date()
                        //                        drawingEntity.updatedAt = drawingEntity.createdAt
                        //
                        //                        self.managedObjectContext.insert(drawingEntity)
                        //
                        //                        try self.managedObjectContext.save()
                    } catch {
                        print("Problem with saving a new DrawingEntity")
                    }
                }
            ).navigationBarTitle(Text("Pencil notes"), displayMode: .large)
        }.navigationViewStyle(StackNavigationViewStyle())
        
        
    }
}

extension DrawingEntity: Identifiable {
    public var id: ObjectIdentifier {
        ObjectIdentifier(self.objectID)
    }
}
