//
//  PencilTab.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import SwiftUI
import CoreData



struct PencilTab: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var environment: AppEnvironment
    
    @FetchRequest(entity: DrawingEntity.entity(), sortDescriptors: [], predicate: nil) var drawings: FetchedResults<DrawingEntity>
    
    var body: some View {
        NavigationView {
            List(drawings) { nodeEntity in
                NavigationLink(destination: PencilCanvas(drawingEntity: nodeEntity)) {
                    Text("asfssdsd")
                }
            
                
            }.navigationBarItems(trailing:
                Text("Add").onTapGesture {
                    do {
                        guard let entity =  NSEntityDescription.entity(forEntityName: "DrawingEntity", in: self.managedObjectContext) else { return }
                        let drawingEntity = DrawingEntity(entity: entity, insertInto: self.managedObjectContext)
                        
                        self.managedObjectContext.insert(drawingEntity)
                        
                        try self.managedObjectContext.save()
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
