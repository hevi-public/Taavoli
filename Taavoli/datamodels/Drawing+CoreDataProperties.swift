//
//  Drawing+CoreDataProperties.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//
//

import Foundation
import CoreData


extension DrawingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrawingEntity> {
        return NSFetchRequest<DrawingEntity>(entityName: "DrawingEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var data: Data?
    @NSManaged public var updatedAt: Date?

}
