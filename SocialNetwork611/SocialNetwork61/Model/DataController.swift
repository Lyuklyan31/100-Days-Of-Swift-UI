//
//  DataController.swift
//  SocialNetwork61
//
//  Created by admin on 14.03.2024.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    
    let container = NSPersistentContainer(name: "Model")
    
    init(inMemory: Bool = false) {
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
         container.loadPersistentStores { description, error in
             if let error = error {
                 print("Core Data fail to load: \(error.localizedDescription)")
                 return
             }
            
             self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
