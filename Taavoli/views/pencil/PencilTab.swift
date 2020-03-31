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
                    Text(drawingEntity.title ?? "")
                }
            }.navigationBarItems(trailing:
                Text("Add").onTapGesture {
                    do {
                        DrawingHttpStore().update(title: "tttitle", data: PKDrawing().dataRepresentation())
                        
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


