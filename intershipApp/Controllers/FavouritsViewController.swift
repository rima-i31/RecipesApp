//
//  FavouritsViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 28.08.2024.
//

import UIKit

class FavouritsViewController: UIViewController {
    
    
    var k = K()
    var user = UserData()
    var recipes: [RecipeModel] = []
    var userRecipes: [RecipeModel] = []
    var favourits: [RecipeModel] = []
    var recipesTableVC = RecipesTableViewController()
    var toggleFav: UIBarButtonItem?
    var isShowingUserRecipes : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavourits()
        recipesTableVC.dataSource = favourits
        addChild(recipesTableVC)
        view.addSubview(recipesTableVC.view)
        recipesTableVC.didMove(toParent: self)
        recipesTableVC.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        
        NotificationCenter.default.addObserver(self, selector: #selector(favouritesDidUpdate), name: .favouritesUpdated, object: nil)
    }
    @objc func favouritesDidUpdate() {
        getFavourits()
        recipesTableVC.dataSource = favourits
        recipesTableVC.tableView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favouritesUpdated, object: nil)
    }
    func getFavourits (){
        if let savedRecipes = user.loadRecipesFromUserDefaults() {
            recipes = savedRecipes
        }
        if let userData = UserData.loadFromDefaults(), let recipes = userData.userRecipes {
            userRecipes = recipes
        }
        let favouriteIDs = CoreDataManager.shared.fetchAllFavouriteRecipeIDs()
        let currentRecipes = isShowingUserRecipes ? userRecipes : recipes
        favourits = currentRecipes.filter { favouriteIDs.contains($0.id) }
        recipesTableVC.dataSource = favourits
        recipesTableVC.tableView.reloadData()
    }
    func updateToggleButtonTitle() {
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.toggleFav?.title = isShowingUserRecipes ? "All Recipes" : "My Recipes"
        }
    }
    func toggleFavButtonTapped() {
        isShowingUserRecipes.toggle()
        updateToggleButtonTitle()
        getFavourits()
    }
}
