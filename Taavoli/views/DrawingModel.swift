//
//  DrawingViewModel.swift
//  Taavoli
//
//  Created by Hevi on 31/03/2020.
//

import Foundation

public class DrawingModel {
    var objectId: String?
    let index: Int
    let title: String
    let data: Data
    
    init(objectId: String? = nil, index: Int = 0, title: String, data: Data) {
        self.index = index
        self.data = data
        self.title = title
        self.objectId = objectId
    }
}

extension DrawingModel: Identifiable {
    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}
