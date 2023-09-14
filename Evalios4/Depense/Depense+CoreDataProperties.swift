//
//  Depense+CoreDataProperties.swift
//  Evalios4
//
//  Created by Duc Luu on 14/09/2023.
//
//

import Foundation
import CoreData


extension Depense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Depense> {
        return NSFetchRequest<Depense>(entityName: "Depense")
    }

    @NSManaged public var nom: String?
    @NSManaged public var date: Date?
    @NSManaged public var valeur: Float
    @NSManaged public var sectionDepense: SectionDepense?

}

extension Depense : Identifiable {

}
