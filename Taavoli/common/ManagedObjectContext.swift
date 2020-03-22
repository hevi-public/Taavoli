//
//  Repository.swift
//  Taavoli
//
//  Created by Hevi on 19/03/2020.
//

import Foundation
import CoreData

class ManagedObjectContext {
    
    static let context = NSManagedObjectContext.getContext()
    
    public static func update() {
        do {
            if context.hasChanges {
                
                context.updatedObjects.forEach { (entity) in
                    (entity as? DrawingEntity)?.updatedAt = Date()
                }
                
                try context.save()
            }
        } catch {
            print("Problem while updating drawing")
        }
    }
    
    public static func getAllEntity(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) -> [DrawingEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DrawingEntity")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            return try context.fetch(fetchRequest) as! [DrawingEntity]
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    public static func get(id: NSManagedObjectID) -> DrawingEntity? {
        return context.object(with: id) as? DrawingEntity
    }
}
