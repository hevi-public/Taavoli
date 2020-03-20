//
//  ContentView.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
    @State var isCameraShown: Bool
    @State var isAlbumShown: Bool
    @State var image: Image?
    
    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selection) {
                    VStack {
                        Spacer()
                        
                        NavigationLink(destination: CaptureImageView(isCameraShown: Binding<Bool>.constant(true), isAlbumShown: Binding<Bool>.constant(false), image: $image)) {
                            VStack {
                                Image(systemName: "camera.fill")
                                Text("Take picture")
                            }
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: CaptureImageView(isCameraShown: Binding<Bool>.constant(false), isAlbumShown: Binding<Bool>.constant(true), image: $image)) {
                            VStack {
                                Image(systemName: "camera.on.rectangle.fill")
                                Text("Album")
                            }
                        }
                        
                        Spacer()
                    }.tabItem {
                        VStack {
                            Image(systemName: "camera.fill")
                            Text("Photo")
                        }
                    }.tag(0)
                    PencilTab().tabItem {
                        VStack {
                            Image(systemName: "pencil")
                            Text("Drawing")
                        }
                    }.tag(1)
                }
                if image != nil {
                    ImageUIScrollViewControllerRepresentable()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isCameraShown: false, isAlbumShown: false, image: nil)
    }
}
