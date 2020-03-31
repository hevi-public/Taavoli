//
//  DrawingRequest.swift
//  Taavoli
//
//  Created by Hevi on 31/03/2020.
//

import Foundation

public class DrawingRequest: Codable {
    var _objectId: String?
    var objectId: String {
        get {
            _objectId ?? UUID().uuidString
        }
        set {
            _objectId = newValue
        }
    }
    let index: Int
    let title: String
    let data: Data
    
    init(objectId: String? = nil, index: Int = 0, title: String, data: Data) {
        self.index = index
        self.data = data
        self.title = title
        self._objectId = objectId
    }
}

extension DrawingRequest: Identifiable {
    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}
