//
//  HomeScreenViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 05.08.2024.
//

import UIKit

class HomeScreenCellController: UITableViewCell {

    @IBOutlet weak var meelImage: UIImageView!
    
    @IBOutlet weak var meelName: UILabel!
    
    
    @IBOutlet weak var ingredients: UILabel!
    
    var recipe:RecipeModel? {
        didSet {
            guard let data = self.recipe else {return}
            self.meelName.text = data.mealName
            self.ingredients.text = data.ingredients
        }
    }
    
}
