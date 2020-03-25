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
    
    @State var shouldDisplayCaptureImageView: Bool = false
    @State var shouldDisplayAlbumView: Bool = false
    
    var isCameraActive: Bool {
        get {
            isCameraShown && !isAlbumShown && shouldDisplayCaptureImageView
        }
    }
    
    var isAlbumActive: Bool {
        get {
            isAlbumShown && !isCameraShown && shouldDisplayAlbumView
        }
    }
    
    
    var body: some View {
        TabView {
            PencilTab().tabItem {
                Image(systemName: "list.dash")
                Text("Menu")
            }
            ImageUIScrollViewControllerRepresentable().tabItem {
                Image(systemName: "list.dash")
                Text("Client")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isCameraShown: false, isAlbumShown: false, image: nil, shouldDisplayCaptureImageView: false)
    }
}
