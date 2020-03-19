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
                try context.save()
            }
        } catch {
            print("Problem while updating drawing")
        }
    }
}
