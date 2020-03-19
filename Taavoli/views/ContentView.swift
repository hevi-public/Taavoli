//
//  ContentView.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
    @State var isShown: Bool
    @State var image: Image?
 
    var body: some View {
        TabView(selection: $selection) {
            ZStack {
                Text("Album")
                CaptureImageView(isShown: $isShown, image: $image)
            }.tabItem {
                VStack {
                    Image(systemName: "camera.fill")
                    Text("Photo")
                }
            }.tag(0)
            AlbumTab(isShown: $isShown, image: $image).tabItem {
                VStack {
                    Image(systemName: "camera.on.rectangle.fill")
                    Text("Album")
                }
            }.tag(1)
            PencilTab().tabItem {
                VStack {
                    Image(systemName: "pencil")
                    Text("Drawing")
                }
            }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isShown: false)
    }
}
