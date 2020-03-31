//
//  PencilTab.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import SwiftUI
import PencilKit


struct PencilTab: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var environment: AppEnvironment
    
    //    @FetchRequest(entity: DrawingEntity.entity(), sortDescriptors: [], predicate: nil) var drawings: FetchedResults<DrawingEntity>
    
    var body: some View {
        NavigationView {
            List(environment.drawings) { drawingEntity in
                NavigationLink(destination: PencilCanvas(drawingModel: drawingEntity)) {
                    Text(drawingEntity.title ?? "")
                }
            }.navigationBarItems(trailing:
                Text("Add").onTapGesture {
                    do {
                        DrawingHttpStore().update(title: "tttitle", data: PKDrawing().dataRepresentation())
                        
                        CoreDataStore().update()
                                                
                    } catch {
                        print("Problem with saving a new DrawingEntity")
                    }
                }
            ).navigationBarTitle(Text("Pencil notes"), displayMode: .large)
        }.navigationViewStyle(StackNavigationViewStyle())
        
        
    }
}


