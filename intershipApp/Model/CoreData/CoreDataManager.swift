//
//  CoreDataManager.swift
//  intershipApp
//
//  Created by Rima Mihova on 26.08.2024.
//

import Foundation
import CoreData
import UIKit




class CoreDataManager{
    static let shared = CoreDataManager()
    private init() {}
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func addFavourite(recipeId: String, isLocal: Bool) {
        let favouriteRecipe = FavouriteRecipe(context: context)
        favouriteRecipe.id = recipeId
        favouriteRecipe.isLocal = isLocal
        saveContext()
        
        NotificationCenter.default.post(name: .favouritesUpdated, object: nil)
    }
    
    func deleteFavourite(recipeId: String){
        let fetchRequest: NSFetchRequest<FavouriteRecipe> = FavouriteRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", recipeId)
        do {
            let results = try context.fetch(fetchRequest)
            if let favouriteRecipe = results.first {
                context.delete(favouriteRecipe)
                saveContext()
                NotificationCenter.default.post(name: .favouritesUpdated, object: nil)
            }
        } catch {
            print("Failed to delete favourite recipe: \(error)")
        }
       
    }
    
    func isFavouriteRecipe(id: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavouriteRecipe> = FavouriteRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let results = try context.fetch(fetchRequest)
            if results.first != nil {
                return true
            }else {
                return false
            }
        } catch {
            print("Failed to delete favourite recipe: \(error)")
            return false
        }
    }
    
    func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func printAllRecipesFromCoreData() {
        let fetchRequest: NSFetchRequest<FavouriteRecipe> = FavouriteRecipe.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                print("No recipes found in Core Data.")
            } else {
                for recipe in results {
                    print("Recipe ID: \(recipe.id ?? "No ID")")
                    print("Is Local: \(recipe.isLocal)")
                    print("-------")
                }
            }
        } catch {
            print("Failed to fetch recipes from Core Data: \(error)")
        }
    }
    func deleteAllRecipesFromCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavouriteRecipe")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
            print("All recipes have been deleted from Core Data.")
        } catch {
            print("Failed to delete all recipes from Core Data: \(error)")
        }
    }
    func fetchAllFavouriteRecipeIDs() -> [String] {
        let fetchRequest: NSFetchRequest<FavouriteRecipe> = FavouriteRecipe.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap { $0.id }
        } catch {
            print("Failed to fetch favourite recipe IDs: \(error)")
            return []
        }
    }


    //    func printRecipeFromCoreData(id: String){
    //        let fetchRequest: NSFetchRequest<FavouriteRecipe> = FavouriteRecipe.fetchRequest()
    //        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
    //        do {
    //            let results = try context.fetch(fetchRequest)
    //            if let safeResult = results.first  {
    //                print(safeResult)
    //            }else {
    //              print("not found recipe")
    //            }
    //        } catch {
    //            print("Failed to delete favourite recipe: \(error)")
    //        }
    //   }
    
}

