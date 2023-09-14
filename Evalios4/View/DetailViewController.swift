//
//  DetailViewController.swift
//  Evalios4
//
//  Created by Duc Luu on 14/09/2023.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {

    @IBOutlet weak var depenseLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valeurLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var passDataObject: Depense?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Format de date souhaité

        let date = passDataObject?.date
        let dateString = dateFormatter.string(from: date!)
        let valeur: String = String(passDataObject!.valeur)
        
        depenseLabel.text = passDataObject?.nom
        sectionLabel.text = passDataObject?.sectionDepense?.nom
        dateLabel.text = dateString
        valeurLabel.text = valeur + " €"
        
        // Utilise AlamofireImage pour télécharger et afficher l'image depuis l'URL
        let nom = passDataObject?.nom?.replacingOccurrences(of: " ", with: "") // supprime tous les espaces
        let url = "https://source.unsplash.com/random?\(nom ?? "Dollar")"
        if let imageURL = URL(string: url) {
            imageView.af.setImage(withURL: imageURL)
        }
    }
    
}
