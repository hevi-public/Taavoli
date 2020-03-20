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
        TabView(selection: $selection) {
            ZStack {
                VStack {
                    Spacer()
                    Button(action: {
                        self.isCameraShown.toggle()
                    }) {
                        VStack {
                            Image(systemName: "camera.fill")
                            Text("Take picture")
                        }
                    }.padding()
                    Spacer()
                    Button(action: {
                        self.isAlbumShown.toggle()
                    }) {
                        VStack {
                            Image(systemName: "camera.on.rectangle.fill")
                            Text("Album")
                        }
                    }.padding()
                    Spacer()
                }
                
                if isCameraShown {
                    CaptureImageView(isShown: $isCameraShown, image: $image)
                }
                if isAlbumShown {
                    AlbumTab(isShown: $isAlbumShown, image: $image)
                }
                if image != nil {
                    ImageUIScrollViewControllerRepresentable()
                }
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isCameraShown: false, isAlbumShown: false, image: nil)
    }
}
