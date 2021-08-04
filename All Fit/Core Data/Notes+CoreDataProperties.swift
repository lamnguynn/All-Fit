//
//  Notes+CoreDataProperties.swift
//  All Fit
//
//  Created by Lam Nguyen on 1/18/21.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var text: String?

}

extension Notes : Identifiable {

}
