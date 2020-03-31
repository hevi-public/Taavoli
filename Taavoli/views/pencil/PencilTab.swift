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
    
    var body: some View {
        NavigationView {
            List(environment.drawings) { drawingEntity in
                NavigationLink(destination: PencilCanvas(drawingModel: drawingEntity)) {
                    Text(drawingEntity.title)
                }
            }.navigationBarItems(trailing:
                Text("Add").onTapGesture {
                    DrawingHttpStore().update(title: "tttitle", data: PKDrawing().dataRepresentation())
                }
            ).navigationBarTitle(Text("Pencil notes"), displayMode: .large)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
