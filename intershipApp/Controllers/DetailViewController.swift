//
//  DetailViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 07.08.2024.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var imageSrc: String?
    var mealName: String?
    var measuredIngredients: String?
    var instructions: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageSrc = imageSrc, let url = URL(string: imageSrc) {
                   URLSession.shared.dataTask(with: url) { data, response, error in
                       if let data = data, error == nil {
                           DispatchQueue.main.async {
                               self.recipeImage.image = UIImage(data: data)
                           }
                       }
                   }.resume()
               }
               //mealNameLabel.text = mealName
               ingredientsLabel.text = measuredIngredients
               instructionsLabel.text = instructions
                self.navigationItem.title = mealName
        let rightBarButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(rightBarButtonTapped))
               self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    @objc func rightBarButtonTapped() {
        
        let textToShare = "\(mealName ?? "") \n \n \(measuredIngredients ?? "") \n \(instructions ?? "") "
        
           let activityController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
           present(activityController, animated: true, completion: nil)
       }

}
