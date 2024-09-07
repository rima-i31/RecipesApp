//
//  AllRecipesViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 28.08.2024.
//

import UIKit

class AllRecipesViewController: UIViewController, RecipeManagerDelegate {
    
    
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    var k = K()
    var recipeManager = RecipeManager()
    var user = UserData()
    var recipes: [RecipeModel] = []
    
    var isLoaded:Bool = false
    var recipesTableVC = RecipesTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.title = "Recipes"
        
        recipeManager.delegate = self
        setupLoadingIndicator()
        
        if let savedRecipes = user.loadRecipesFromUserDefaults() {
            recipes = savedRecipes
            isLoaded = true
            loadingIndicator.stopAnimating()
            setupRecipesTable()
        } else {
            loadRandomRecipes()
        }
        
    }
    func setupRecipesTable() {
        recipesTableVC.dataSource = recipes
        addChild(recipesTableVC)
        view.addSubview(recipesTableVC.view)
        recipesTableVC.didMove(toParent: self)
        recipesTableVC.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    func setupLoadingIndicator() {
        loadingIndicator.center = view.center
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    func loadRandomRecipes() {
        CoreDataManager.shared.deleteAllRecipesFromCoreData()
        CoreDataManager.shared.printAllRecipesFromCoreData()
        for _ in 1...k.recipesCount {
            recipeManager.getRecipes()
        }
    }
    func didUpdateRecipe(newRecipe: RecipeModel) {
        DispatchQueue.main.async {
            var isNew = true
            for i in 0..<self.recipes.count{
                if newRecipe.id == self.recipes[i].id{
                    isNew = false
                }
            }
            if isNew{
                self.recipes.append(newRecipe)
            }else{
                self.recipeManager.getRecipes()
            }
            
            if self.recipes.count == self.k.recipesCount {
                self.isLoaded = true
                self.loadingIndicator.stopAnimating()
                self.recipesTableVC.dataSource = self.recipes
                self.user.saveRecipesToUserDefaults(self.recipes)
                self.setupRecipesTable()
            }
        }
    }
    
    func didFailWithError(error: any Error) {
        print(error)
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    
}
