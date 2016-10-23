//
//  CoreDateStack.swift
//  UNote
//
//  Created by SUNGKAHO on 21/10/2016.
//  Copyright © 2016年 EE4304. All rights reserved.
//

import Foundation
import CoreData

class CourseListCore : NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Core")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
