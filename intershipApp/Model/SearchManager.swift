//
//  SearchManager.swift
//  intershipApp
//
//  Created by Rima Mihova on 09.08.2024.
//

import Foundation
struct SearchManager{
   
    func search(recipe name: String, in recipes: [RecipeModel])->[RecipeModel]{
        var foundRecipes: [RecipeModel] = []
        for i in 0..<recipes.count{
           
            if recipes[i].mealName.localizedCaseInsensitiveContains(name) || recipes[i].ingredients.localizedCaseInsensitiveContains(name) {
                           foundRecipes.append(recipes[i])
                       }
        }
        return foundRecipes
    }
    
}
