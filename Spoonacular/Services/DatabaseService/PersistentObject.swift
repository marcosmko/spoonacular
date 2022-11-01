//
//  PersistentObject.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation
import CoreData

class PersistentObject: NSManagedObject {
    
    init() {
        let entityDescription = PersistenceController.shared.create(String(describing: Swift.type(of: self)))
        super.init(entity: entityDescription, insertInto: nil)
    }
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
}
