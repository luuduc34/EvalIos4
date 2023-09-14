//
//  SectionDepense+CoreDataProperties.swift
//  Evalios4
//
//  Created by Duc Luu on 14/09/2023.
//
//

import Foundation
import CoreData


extension SectionDepense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SectionDepense> {
        return NSFetchRequest<SectionDepense>(entityName: "SectionDepense")
    }

    @NSManaged public var nom: String?
    @NSManaged public var depenses: Set<Depense>?

}

// MARK: Generated accessors for depenses
extension SectionDepense {

    @objc(addDepensesObject:)
    @NSManaged public func addToDepenses(_ value: Depense)

    @objc(removeDepensesObject:)
    @NSManaged public func removeFromDepenses(_ value: Depense)

    @objc(addDepenses:)
    @NSManaged public func addToDepenses(_ values: NSSet)

    @objc(removeDepenses:)
    @NSManaged public func removeFromDepenses(_ values: NSSet)

}

extension SectionDepense : Identifiable {

}
