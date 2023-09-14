//
//  SectionViewController.swift
//  Evalios4
//
//  Created by Duc Luu on 14/09/2023.
//

import UIKit
import CoreData

class SectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var sectionTableView: UITableView!
    
    let context = DataManager.shared.context
    var resultsController: NSFetchedResultsController<SectionDepense>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // fetch des données
        let fetchRequest = SectionDepense.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: true)] // query: filtré par nom
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil
        )
        
        do {
            try resultsController.performFetch()
        } catch {
            print("Could not fetch receipes : ", error)
        }
        
        sectionTableView.dataSource = self
        resultsController.delegate = self
    }

    // gère la tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = resultsController.object(at: indexPath).nom
        return cell
    }
    
    // ajout de la fonction "slide, effacer"
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let section = resultsController.object(at: indexPath)
            DataManager.shared.deleteSectionDepense(section: section)
        }
    }
    
    // gère l'écoute et la mise à jour auto de la tableview (éléments)
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sectionTableView.endUpdates()
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sectionTableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            sectionTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            sectionTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            sectionTableView.deleteRows(at: [indexPath!], with: .automatic)
            sectionTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            sectionTableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    @IBAction func ajoutSectionBtn(_ sender: UIBarButtonItem) {
        addSection()
    }
    
    func addSection() {
        let alertController = UIAlertController(title: "Ajouter", message: "Entrez la nouvelle section", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let textField = alertController.textFields?.first, let section = textField.text {
                
                if (!section.isEmpty) {
                    DataManager.shared.addSectionDepense(nom: section)
                } else {
                    return
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
