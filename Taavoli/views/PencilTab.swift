//
//  PencilTab.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import SwiftUI

struct PencilTab: View {
    var body: some View {
        PencilCanvas()
        .font(.title)
    }
}

struct PencilTab_Previews: PreviewProvider {
    static var previews: some View {
        PencilTab()
    }
}
