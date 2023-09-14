//
//  AddDepenseViewController.swift
//  Evalios4
//
//  Created by Duc Luu on 14/09/2023.
//

import UIKit
import CoreData

class AddDepenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var valeurLabel: UITextField!
    @IBOutlet weak var nomLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var sectionDepenseTableView: UITableView!
    
    let context = DataManager.shared.context
    var selectedDate: Date?
    var selectedSection: SectionDepense?
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
        sectionDepenseTableView.dataSource = self
        sectionDepenseTableView.delegate = self
        
        // écoute les changement de date picker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = resultsController.object(at: indexPath).nom
        return cell
    }
    // récupère le choix de section
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSection = resultsController.object(at: indexPath)
    }

    // enregistre les changement de date picker dans la variable
    @objc func datePickerValueChanged(_ datePicker: UIDatePicker) {
        selectedDate = datePicker.date
    }
    
    @IBAction func saveBtn() {
        
        guard let selectedDate = selectedDate else {
            let alert = UIAlertController(title: "Erreur", message: "Veuillez sélectionner une date.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let selectedSection = selectedSection else {
            let alert = UIAlertController(title: "Erreur", message: "Veuillez sélectionner une section.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (!nomLabel.text!.isEmpty && !valeurLabel.text!.isEmpty) {
            guard let valeurText = valeurLabel.text, let valeur = Float(valeurText) else { return }
            DataManager.shared.addDepense(nom: nomLabel.text!, date: selectedDate, valeur: valeur, section: selectedSection)
            dismiss(animated: true)
        } else {
            showAlert(titre: "Erreur", message: "Veuiller remplir tous les champs")
        }
        dismiss(animated: true)
    }

    @IBAction func cancelBtn() {
        dismiss(animated: true)
    }
    
    func showAlert(titre: String, message: String) {
        let alertController = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
