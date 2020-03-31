//
//  CoreDataStore.swift
//  Taavoli
//
//  Created by Hevi on 31/03/2020.
//

import Foundation
import CoreData

public class CoreDataStore {
    
    public func update() {
        do {
            guard let entity =  NSEntityDescription.entity(forEntityName: "DrawingEntity", in: ManagedObjectContext.context) else { return }
            let drawingEntity = DrawingEntity(entity: entity, insertInto: ManagedObjectContext.context)
            
            drawingEntity.createdAt = Date()
            drawingEntity.updatedAt = drawingEntity.createdAt
            
            ManagedObjectContext.context.insert(drawingEntity)
            
            try ManagedObjectContext.context.save()
        } catch {
            print(error)
        }
    }
    
    public func getAll() -> [DrawingEntity] {
        return ManagedObjectContext.getAllEntity(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)])
    }
}
