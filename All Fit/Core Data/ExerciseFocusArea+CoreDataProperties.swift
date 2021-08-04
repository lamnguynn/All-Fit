//
//  ExerciseFocusArea+CoreDataProperties.swift
//  All Fit
//
//  Created by Lam Nguyen on 1/16/21.
//
//

import Foundation
import CoreData


extension ExerciseFocusArea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseFocusArea> {
        return NSFetchRequest<ExerciseFocusArea>(entityName: "ExerciseFocusArea")
    }

    @NSManaged public var name: String?

}

extension ExerciseFocusArea : Identifiable {

}
