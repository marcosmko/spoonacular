//
//  DatabaseService.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation
import CoreData

protocol Entity {
    associatedtype Key: Hashable
    var id: Key { get }
}

protocol DatabaseObject: Entity where Self: NSManagedObject {
    associatedtype T: DatabaseObject
    static func fetchRequest() -> NSFetchRequest<T>
}

class DatabaseService<T: DatabaseObject> {
    
    static func fetchAll() throws -> [T] {
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        return try PersistenceController.shared.fetch(request)
    }
    
    static func find(_ id: T.Key) throws -> T? {
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %d", id as! CVarArg)
        return try PersistenceController.shared.fetch(request).first
    }
    
    static func save(_ object: T) throws {
        try PersistenceController.shared.insert(object)
    }
    
    static func save(_ objects: [T]) throws {
        try PersistenceController.shared.insert(objects)
    }
    
    static func delete(_ object: T) throws {
        try PersistenceController.shared.delete(object)
    }
    
    static func delete(_ objects: [T]) throws {
        try PersistenceController.shared.delete(objects)
    }
    
}
