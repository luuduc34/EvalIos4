//
//  DataManager.swift
//  Evalios4
//
//  Created by Duc Luu on 14/09/2023.
//

import Foundation
import CoreData

class DataManager {
    
    static var shared = DataManager()
    
    let context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "Depense")
        
        let dbFileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("db.sqlite")
        
        let storeDescription = NSPersistentStoreDescription(url: dbFileURL)
        storeDescription.type = NSSQLiteStoreType
        
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores {
            description, error in
            if let error = error {
                print("Error loading persistent store: ", error)
            }
        }
        
        context = container.viewContext
    }
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context", error)
        }
    }
    // méthode pour ajouter recette
    func addDepense(nom: String, date: Date, valeur: Float, section: SectionDepense) {
        let depense = Depense(context: context)
        depense.nom = nom
        depense.date = date
        depense.valeur = valeur
        depense.sectionDepense = section
        
        saveContext()
    }
    // méthode pour effacer recette
    func deleteDepense(depense: Depense) {
        context.delete(depense)

        saveContext()
    }
    // méthode pour ajouter type de cuisine
    func addSectionDepense(nom: String) {
        let section = SectionDepense(context: context)
        section.nom = nom
        
        saveContext()
    }
    // méthode pour effacer un type de recette
    func deleteSectionDepense(section: SectionDepense) {
        context.delete(section)

        saveContext()
    }
}

