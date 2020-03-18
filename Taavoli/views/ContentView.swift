//
//  ContentView.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            Text("Photo")
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: "camera.fill")
                    Text("Photo")
                }
            }
            .tag(0)
            Text("Album")
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: "camera.on.rectangle.fill")
                    Text("Album")
                }
            }
            .tag(1)
            PencilCanvas()
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: "pencil")
                    Text("Drawing")
                }
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
