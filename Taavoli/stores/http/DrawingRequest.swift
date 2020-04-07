//
//  DrawingRequest.swift
//  Taavoli
//
//  Created by Hevi on 31/03/2020.
//

import Foundation

public class DrawingRequest: Codable {
    var id: String?
    let index: Int
    let title: String
    let data: Data?
    
    init(id: String? = nil, index: Int = 0, title: String, data: Data?) {
        self.id = id
        self.index = index
        self.data = data
        self.title = title
    }
}


