//
//  Persistence.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Spoonacular")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    lazy var viewContext: NSManagedObjectContext = {
        let viewContext = self.container.newBackgroundContext()
        viewContext.mergePolicy = NSMergePolicy.overwrite
        return viewContext
    }()
    
    func create(_ entity: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entity, in: self.viewContext)!
    }
    
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] {
        let context: NSManagedObjectContext = self.viewContext
        return try context.fetch(request)
    }
    
    private func insertAtContext(_ object: NSManagedObject) {
        guard object.managedObjectContext == nil else {
            return
        }
        let context: NSManagedObjectContext = self.viewContext
        context.insert(object)
        for object in object.entity.relationshipsByName.map({ object.value(forKey: $0.key) }) {
            if let object = object as? NSManagedObject {
                self.insertAtContext(object)
            } else if let objects = (object as? NSSet)?.allObjects as? [NSManagedObject] {
                objects.forEach(self.insertAtContext)
            } else if let objects = (object as? NSOrderedSet)?.array as? [NSManagedObject] {
                objects.forEach(self.insertAtContext)
            } else if object != nil {
                preconditionFailure("should not happen")
            }
        }
    }
    
    func insert(_ object: NSManagedObject) throws {
        let context: NSManagedObjectContext = self.viewContext
        self.insertAtContext(object)
        do {
            try context.save()
        } catch {
            context.delete(object)
            throw error
        }
    }
    
    func insert(_ objects: [NSManagedObject]) throws {
        let context: NSManagedObjectContext = self.viewContext
        objects.forEach(self.insertAtContext)
        do {
            try context.save()
        } catch {
            objects.forEach(context.delete)
            throw error
        }
    }
    
    func update(_ object: NSManagedObject) throws {
        try object.managedObjectContext?.save()
    }
    
    func delete(_ object: NSManagedObject) throws {
        let context: NSManagedObjectContext = self.viewContext
        context.delete(object)
        try context.save()
    }
    
    func delete(_ objects: [NSManagedObject]) throws {
        let context: NSManagedObjectContext = self.viewContext
        objects.forEach(context.delete)
        try context.save()
    }
    
    func clear() {
        let context: NSManagedObjectContext = self.viewContext
        for entity in self.container.managedObjectModel.entities {
            guard let name = entity.name else { continue }
            let query = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let request = NSBatchDeleteRequest(fetchRequest: query)
            do {
                try context.execute(request)
                try context.save()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
}
