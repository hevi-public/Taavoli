//
//  DrawingStore.swift
//  Taavoli
//
//  Created by Hevi on 06/04/2020.
//

import Foundation

public protocol DrawingStore {
    
    func save(title: String, data: Data, completion: @escaping () -> ())
    
    func update(id: String, title: String, data: Data, completion: @escaping () -> ())

    func get(id: String, completion: @escaping (DrawingModel) -> ())
    
    func getAll(completion: @escaping ([DrawingModel]) -> ())
    
    func delete(id: String)
}
