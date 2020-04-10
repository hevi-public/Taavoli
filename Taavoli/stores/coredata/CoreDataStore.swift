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
            guard let entity =  NSEntityDescription.entity(forEntityName: "DrawingEntity", in: NSManagedObjectContext.getContext()) else { return }
            let drawingEntity = DrawingEntity(entity: entity, insertInto: NSManagedObjectContext.getContext())
            
            drawingEntity.title = title
            drawingEntity.data = data
            let now = Date()
            drawingEntity.createdAt = now
            drawingEntity.updatedAt = now
            
            NSManagedObjectContext.getContext().insert(drawingEntity)
            
            ManagedObjectContext.update()
        } catch {
            print(error)
        }
    }
    
    public func update(id: String, title: String, data: Data, completion: @escaping () -> ()) {
        do {
            guard let entity =  NSEntityDescription.entity(forEntityName: "DrawingEntity", in: NSManagedObjectContext.getContext()) else { return }
            let drawingEntity = DrawingEntity(entity: entity, insertInto: NSManagedObjectContext.getContext())
            
            drawingEntity.createdAt = Date()
            drawingEntity.updatedAt = drawingEntity.createdAt
            
            NSManagedObjectContext.getContext().insert(drawingEntity)
            
            ManagedObjectContext.update()
        } catch {
            print(error)
        }
    }
    
    public func get(id: String, completion: @escaping (DrawingModel) -> ()) {
        guard let objectIDURL = URL(string: id) else { return }
        guard let coordinator: NSPersistentStoreCoordinator = NSManagedObjectContext.getContext().persistentStoreCoordinator else { return }
        guard let managedObjectID = coordinator.managedObjectID(forURIRepresentation: objectIDURL) else { return }
        
        let drawingEntity = ManagedObjectContext.get(id: managedObjectID)
            
        let drawingModel = DrawingModel(objectId: drawingEntity?.objectID.uriRepresentation().absoluteString, title: drawingEntity?.title ?? "", data: drawingEntity?.data)
        
        completion(drawingModel)
    }
    
    public func getAll(completion: @escaping ([DrawingModel]) -> ()) {
        let entities = ManagedObjectContext.getAllEntity(predicate: nil, sortDescriptors: [])
        let drawings = entities.map { (entity) -> DrawingModel in
            DrawingModel(objectId: entity.objectID.uriRepresentation().absoluteString, title: entity.title ?? "NO TITLE", data: entity.data)
        }
        completion(drawings)
    }
    
    public func delete(id: String) {
        
    }
    
}
