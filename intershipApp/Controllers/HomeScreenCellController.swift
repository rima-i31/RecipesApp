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
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var recipe: RecipeModel? {
        
        didSet {
            guard let data = recipe else { return }
            meelName.text = data.mealName
            ingredients.text = data.ingredients
            ImageLoader.shared.loadImage(from: data.imageSrc, into: meelImage, with: indicator)
        }
    }
}
