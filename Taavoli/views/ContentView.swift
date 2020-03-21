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
        NavigationView {
            ZStack {
                TabView(selection: $selection) {
                    VStack {
                        Spacer()
                        
                        NavigationLink(
                            destination: CaptureImageView(isCameraShown: Binding<Bool>.constant(true), isAlbumShown: Binding<Bool>.constant(false), image: $image, shouldDisplayCaptureImageView: $shouldDisplayCaptureImageView, shouldDisplayAlbumView: $shouldDisplayAlbumView),
                            isActive: $shouldDisplayCaptureImageView) {
                                VStack {
                                    Image(systemName: "camera.fill")
                                    Text("Take picture")
                                }
                        }
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: CaptureImageView(isCameraShown: Binding<Bool>.constant(false), isAlbumShown: Binding<Bool>.constant(true), image: $image, shouldDisplayCaptureImageView: $shouldDisplayCaptureImageView, shouldDisplayAlbumView: $shouldDisplayAlbumView),
                            isActive: $shouldDisplayCaptureImageView) {
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
            }.navigationBarItems(
                trailing: Button(action: {
//                    self.showingChildView = true
                    
                }) {
                    Text("Next")
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isCameraShown: false, isAlbumShown: false, image: nil, shouldDisplayCaptureImageView: false)
    }
}
