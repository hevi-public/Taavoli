//
//  CoreDataStore.swift
//  Taavoli
//
//  Created by Hevi on 31/03/2020.
//

import Foundation
import CoreData

public class CoreDataStore: DrawingStore {
    
    public func save(title: String, data: Data, completion: @escaping () -> ()) {
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
    
    public func update(id: String, title: String, data: Data, completion: @escaping () -> ()) {
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
    
    public func get(id: String, completion: @escaping (DrawingModel) -> ()) {
        
    }
    
    public func getAll(completion: @escaping ([DrawingModel]) -> ()) {
        let entities = ManagedObjectContext.getAllEntity(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)])
        let drawings = entities.map { (entity) -> DrawingModel in
            DrawingModel(objectId: entity.objectID.uriRepresentation().absoluteString, title: entity.title ?? "", data: entity.data)
        }
        completion(drawings)
    }
    
    public func delete(id: String) {
        
    }
    
}
