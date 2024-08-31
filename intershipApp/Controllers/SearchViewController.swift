//
//  SearchViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 28.08.2024.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var k = K()
    var isShowingUserRecipes : Bool = false
    var searcManager = SearchManager()
    var recipesTableVC = RecipesTableViewController()
    var recipes: [RecipeModel] = []
    var userRecipes: [RecipeModel] = []
    var foundRecipes: [RecipeModel] = []
    var user = UserData()
    var toggleSearch: UIBarButtonItem?
    override func viewDidLoad() {
        
        searchTextField.delegate = self
        
        if let savedRecipes = user.loadRecipesFromUserDefaults() {
            recipes = savedRecipes
        }
        loadUserRecipes()
        self.reload()
        
        recipesTableVC.updateData(foundRecipes)
        addChild(recipesTableVC)
        view.addSubview(recipesTableVC.view)
        recipesTableVC.didMove(toParent: self)
        recipesTableVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recipesTableVC.view.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            recipesTableVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesTableVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipesTableVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadUserRecipes() {
//        if let userData = UserData.loadFromDefaults(), let recipes = userData.userRecipes {
//            userRecipes = recipes
//            recipesTableVC.tableView.reloadSections(self.k.indexSet, with: .fade)
//        }
        if let userData = UserData.loadFromDefaults(), let recipes = userData.userRecipes {
                    userRecipes = recipes
                } else {
                    userRecipes = []
                }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload), object: nil)
        if let searchText = searchTextField.text, !searchText.isEmpty {
            self.perform(#selector(reload), with: nil, afterDelay: 0.7)
        } else {
            foundRecipes.removeAll()
            self.reload()
        }
    }
    
    @objc func reload() {
        if let name = searchTextField.text, !name.isEmpty {
            foundRecipes = isShowingUserRecipes ? searcManager.search(recipe: name, in: userRecipes) : searcManager.search(recipe: name, in: recipes)
        } else {
            foundRecipes = isShowingUserRecipes ? userRecipes : recipes
        }
        recipesTableVC.updateData(foundRecipes)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    func updateToggleButtonTitle() {
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.toggleSearch?.title = isShowingUserRecipes ? "All Recipes" : "My Recipes"
        }
    }
    
    func toggleButtonTapped() {
        isShowingUserRecipes.toggle()
        loadUserRecipes()  
        updateToggleButtonTitle()
        reload()
    }
}
