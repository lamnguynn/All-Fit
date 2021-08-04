//
//  ExerciseItem+CoreDataProperties.swift
//  All Fit
//
//  Created by Lam Nguyen on 1/16/21.
//
//

import Foundation
import CoreData


extension ExerciseItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseItem> {
        return NSFetchRequest<ExerciseItem>(entityName: "ExerciseItem")
    }

    @NSManaged public var focusArea: String?
    @NSManaged public var name: String?
    @NSManaged public var needEquipment: Bool
    @NSManaged public var summary: String?
    @NSManaged public var unit: String?

}

extension ExerciseItem : Identifiable {

}
