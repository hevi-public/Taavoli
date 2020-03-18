//
//  Drawing+CoreDataProperties.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//
//

import Foundation
import CoreData


extension Drawing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drawing> {
        return NSFetchRequest<Drawing>(entityName: "Drawing")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var data: Data?
    @NSManaged public var updatedAt: Date?

}
