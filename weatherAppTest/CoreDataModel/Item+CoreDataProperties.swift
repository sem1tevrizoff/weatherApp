//
//  Item+CoreDataProperties.swift
//  weatherAppTest
//
//  Created by sem1 on 24.07.22.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?

}

extension Item : Identifiable {

}
