//
//  Repository.swift
//  Taavoli
//
//  Created by Hevi on 19/03/2020.
//

import Foundation
import CoreData

class ManagedObjectContext {
    
    public static func update() {
        do {
            if NSManagedObjectContext.getContext().hasChanges {
                try NSManagedObjectContext.getContext().save()
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
            return try NSManagedObjectContext.getContext().fetch(fetchRequest) as! [DrawingEntity]
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    public static func get(id: NSManagedObjectID) -> DrawingEntity? {
        return NSManagedObjectContext.getContext().object(with: id) as? DrawingEntity
    }
}
