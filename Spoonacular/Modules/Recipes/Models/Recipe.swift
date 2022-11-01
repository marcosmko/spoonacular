//
//  Recipe.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation
import CoreData

final class Recipe: NSManagedObject, DatabaseObject, Identifiable {
    @NSManaged var id: Int
    @NSManaged var title: String
    @NSManaged var summary: String?
    @NSManaged var image: URL?
    @NSManaged var isFavorited: Bool
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

}

extension Recipe: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case summary
        case image
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.summary ?= (try container.decodeIfPresent(String.self, forKey: .summary))
        self.image ?= (try container.decodeIfPresent(URL.self, forKey: .image))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.summary, forKey: .summary)
        try container.encodeIfPresent(self.image, forKey: .image)
    }
    
}

