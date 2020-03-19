//
//  PencilTab.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import SwiftUI
import CoreData



struct PencilTab: View {
    
    @FetchRequest(entity: DrawingEntity.entity(), sortDescriptors: [], predicate: nil) var drawings: FetchedResults<DrawingEntity>
    
    var body: some View {
        NavigationView {
            List(drawings) { nodeEntity in
                Group {
//                    NavigationLink(destination: PencilCanvas(drawingEntity: drawingEntity, environment: _environment)) {
                        Text("asfssdsd")
//                    }
                }
                
            }.navigationBarItems(trailing:
                Text("Add").onTapGesture {
//                    _ = NodeRepository.save(content: "", connectionId: nil, category: .c7, isDrawing: true)
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
