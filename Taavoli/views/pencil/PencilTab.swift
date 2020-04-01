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
    
    @State var showTextInput = false
    @Binding var textInputText: String
    
    var body: some View {
        NavigationView {
            VStack {
                if self.showTextInput {
                    TextField("", text: $textInputText)
                        .padding()
                        .background(Color(.lightGray))
                        .cornerRadius(10)
                        .animation(Animation.default)
                        .transition(.move(edge: .leading))
                }
                List(environment.drawings) { drawingEntity in
                    NavigationLink(destination: PencilCanvas(drawingModel: drawingEntity)) {
                        Text(drawingEntity.title)
                            .contextMenu {
                                Button(action: {
                                    if let id = drawingEntity.objectId {
                                        DrawingHttpStore().delete(id: id)
                                    }
                                }) {
                                    Text("Delete")
                                    Image(systemName: "xmark.circle")
                                }
                                .onTapGesture {
                                    self.environment.update()
                                }
                                
                        }
                        
                    }
                }.disabled(showTextInput)
                    .blur(radius: showTextInput ? 3 : 0)
                    .animation(Animation.default)
                    .transition(.slide)
                    .navigationBarItems(leading:
                        Button(action: {
                            withAnimation {
                                self.showTextInput.toggle()
                            }
                        }, label: {
                            if self.showTextInput {
                                Text("Cancel")
                            }
                        })
                        , trailing:
                        Button(action: {
                            if self.showTextInput && !self.textInputText.isEmpty {
                                DrawingHttpStore().update(title: self.textInputText, data: PKDrawing().dataRepresentation())
                            }
                            withAnimation {
                                self.showTextInput.toggle()
                            }
                            
                        }, label: {
                            if self.showTextInput && !self.textInputText.isEmpty {
                                Text("Save")
                            } else if !self.showTextInput {
                                Text("Add")
                            }
                        })
                        
                        
                        
                        
                        
                        
                ).navigationBarTitle(Text("Pencil notes"), displayMode: .large)
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
