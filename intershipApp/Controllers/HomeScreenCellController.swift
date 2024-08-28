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
    
    @IBOutlet weak var toFavButton: UIButton!
    
    var isFavorite = false
    var recipe: RecipeModel? {
        
        didSet {
            guard let data = recipe else { return }
            meelName.text = data.mealName
            ingredients.text = data.ingredients
            ImageLoader.shared.loadImage(from: data.imageSrc, into: meelImage, with: indicator)
            if CoreDataManager.shared.isFavouriteRecipe(id: data.id) {
                setFavoriteState()
            } else {
                setUnfavoriteState()
            }
        }
        
    }
    
    @IBAction func toFavTapped(_ sender: UIButton) {
        guard let recipeID = recipe?.id, let isLocalRecipe = recipe?.isLocal else { return }
            let isCurrentlyFavorite = CoreDataManager.shared.isFavouriteRecipe(id: recipeID)
            if !isCurrentlyFavorite {
                setFavoriteState()
                CoreDataManager.shared.addFavourite(recipeId: recipeID, isLocal: isLocalRecipe)
                CoreDataManager.shared.printAllRecipesFromCoreData()
            } else {
                setUnfavoriteState()
                CoreDataManager.shared.deleteFavourite(recipeId: recipeID)
            }
        //CoreDataManager.shared.printRecipeFromCoreData(id: recipeID)
        CoreDataManager.shared.printAllRecipesFromCoreData()
    }
    
    private func setFavoriteState() {
        toFavButton.tintColor = .yellow
        toFavButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    private func setUnfavoriteState() {
        toFavButton.tintColor = .gray
        toFavButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
}
