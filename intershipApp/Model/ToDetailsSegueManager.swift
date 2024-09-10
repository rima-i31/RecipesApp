//
//  ToDetailsSegueManager.swift
//  intershipApp
//
//  Created by Rima Mihova on 10.08.2024.
//

import Foundation

struct ToDetailsSegueManager{
    func trnsferData(from selectedCell: RecipeModel, to destinationVC: DetailViewController){
        destinationVC.imageSrc = selectedCell.imageSrc
        destinationVC.mealName = selectedCell.mealName
        destinationVC.measuredIngredients = selectedCell.measuredIngredients
        destinationVC.instructions = selectedCell.instructions
        destinationVC.idRecipe = selectedCell.id
    }
}
