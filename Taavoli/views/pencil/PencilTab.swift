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
    @State var editedDrawing: DrawingModel?
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
                                    if let _ = drawingEntity.objectId {
                                        self.showTextInput.toggle()
                                        self.textInputText = drawingEntity.title
                                        self.editedDrawing = drawingEntity
                                    }
                                }) {
                                    Text("Edit")
                                    Image(systemName: "pencil.and.ellipsis.rectangle")
                                }
                                
                                Button(action: {
                                    if let id = drawingEntity.objectId {
                                        DrawingHttpStore().delete(id: id)
                                    }
                                }) {
                                    Text("Delete")
                                    Image(systemName: "xmark.circle")
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
                                if self.showTextInput {
                                    self.textInputText = ""
                                    self.editedDrawing = nil
                                }
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
                                let data: Data
                                if let editedDrawing = self.editedDrawing {
                                    data = editedDrawing.data
                                } else {
                                    data = PKDrawing().dataRepresentation()
                                }
                                    
                                DrawingHttpStore().update(id: self.editedDrawing?.objectId,
                                                            title: self.textInputText,
                                                          data: data,
                                                          completion: {
                                                            self.environment.update()
                                })
                                
                                self.textInputText = ""
                                self.editedDrawing = nil
                                
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
