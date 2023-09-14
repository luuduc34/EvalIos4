//
//  DepenseViewController.swift
//  Evalios4
//
//  Created by Duc Luu on 14/09/2023.
//

import UIKit
import CoreData

class DepenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var depenseTableView: UITableView!
    
    let context = DataManager.shared.context
    var resultsController: NSFetchedResultsController<Depense>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // fetch des données
        let fetchRequest = NSFetchRequest<Depense>(entityName: "Depense")
        fetchRequest.sortDescriptors = [
            // query: filtre d'abord par nom de type
            NSSortDescriptor(key: "sectionDepense.nom", ascending: true),
            // query: filtre par nom
            NSSortDescriptor(key: "nom", ascending: true)
        ]
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "sectionDepense.nom", cacheName: nil
        )
        do {
            try resultsController.performFetch()
        } catch {
            print("Could not fetch receipes : ", error)
        }
        
        depenseTableView.dataSource = self
        depenseTableView.delegate = self // on doit gerder celui ci pour le click sur la cellule
        resultsController.delegate = self // on doit garder celui ci pour la mise a jour auto de la tableview
        // lier le nib avec la customCell
        depenseTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CustomTableViewCell")
    }
    // gère la tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let depense = resultsController?.object(at: indexPath)
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        /*
        let cell = UITableViewCell()
        let valeur: String = String(resultsController.object(at: indexPath).valeur) + "€"
        cell.textLabel?.text = (resultsController.object(at: indexPath).nom!) + "                               " + valeur
         
        return cell*/
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Format de date souhaité

        let date = depense?.date
        let dateString = dateFormatter.string(from: date!)
        let valeur: String = String(depense!.valeur)
        customCell.dateLabel.text = dateString
        customCell.depenseLabel.text = depense?.nom
        customCell.valeurLabel.text = valeur + " €"
        return customCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController.sections?.count ?? 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return resultsController.sections?[section].name
    }
    
    // ajout de la fonction "slide, effacer"
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let depense = resultsController.object(at: indexPath)
            DataManager.shared.deleteDepense(depense: depense)
        }
    }
    
    // gère l'écoute et la mise à jour auto de la tableview (catégories)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            depenseTableView.insertSections([sectionIndex], with: .automatic)
        case .delete:
            depenseTableView.deleteSections([sectionIndex], with: .automatic)
        default:
            break
        }
    }
    // gère l'écoute et la mise à jour auto de la tableview
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        depenseTableView.endUpdates()
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        depenseTableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            depenseTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            depenseTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            depenseTableView.deleteRows(at: [indexPath!], with: .automatic)
            depenseTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            depenseTableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    // bouuton pour ajouter une dépense
    @IBAction func ajoutBtn() {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "AddDepenseViewController")
        else {
            fatalError("Unable to instantiate AddDepenseViewController")
        }
        present(viewController, animated: true)
    }
    
}
