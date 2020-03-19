//
//  NSManagedObjectExtension.swift
//  Taavoli
//
//  Created by Hevi on 19/03/2020.
//

import Foundation
import CoreData
import UIKit

extension NSManagedObjectContext {

    public static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}
