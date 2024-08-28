//
//  HomeScreenViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 05.08.2024.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    
    @IBOutlet weak var homeTableView: UITableView!
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    var k = K()
    var searcManager = SearchManager()
    var recipeManager = RecipeManager()
    var toDetails = ToDetailsSegueManager()
    var addRecipeVC = AddRecipeViewController()
    var user = UserData()
    var recipes: [RecipeModel] = []
    var foundRecipes: [RecipeModel] = []
    var userRecipes: [RecipeModel] = []
    var isOnSearch:Bool = false
    var isLoading: Bool = true
    var isLoaded:Bool = false
    var isShowingUserRecipes: Bool = false
    var myRecipeButtonTittle = "My Recipes"
    var addButton: UIBarButtonItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Recipes"
        self.navigationItem.hidesBackButton = true
        let myRecipesButton = UIBarButtonItem(title: myRecipeButtonTittle, style: .plain, target: self, action: #selector(myRecipesButtonTapped))
        self.navigationItem.rightBarButtonItem = myRecipesButton
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton?.isHidden = true
        navigationItem.leftBarButtonItem = addButton
        
        searchTextField.delegate = self
        recipeManager.delegate = self
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: k.idCell, bundle: nil), forCellReuseIdentifier: k.idCell)
        homeTableView.register(UINib(nibName: k.idErrorCell, bundle: nil), forCellReuseIdentifier: k.idErrorCell)
        
        setupLoadingIndicator()
        loadingIndicator.startAnimating()
        //        loadRandomRecipes()
        //
        //        loadUserRecipes()
        //        homeTableView.reloadData()
        //    }
        if let savedRecipes = user.loadRecipesFromUserDefaults() {
            recipes = savedRecipes
            isLoading = false
            isLoaded = true
            loadingIndicator.stopAnimating()
        } else {
            loadRandomRecipes()
        }
        
        loadUserRecipes()
        homeTableView.reloadData()
    }
    
    
    func loadUserRecipes() {
        if let userData = UserData.loadFromDefaults(), let recipes = userData.userRecipes {
            userRecipes = recipes
            homeTableView.reloadSections(self.k.indexSet, with: .fade)
        }
    }
    
    func loadRandomRecipes() {
        CoreDataManager.shared.deleteAllRecipesFromCoreData()
       CoreDataManager.shared.printAllRecipesFromCoreData()
        for _ in 1...k.recipesCount {
            recipeManager.getRecipes()
        }
    }
    func setupLoadingIndicator() {
        loadingIndicator.center = view.center
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton){
        view.endEditing(true)
    }
    
    deinit {
        ImageCache.shared.clearCache()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ImageCache.shared.clearCache()
    }
    @objc func myRecipesButtonTapped() {
        isShowingUserRecipes.toggle()
        myRecipeButtonTittle = isShowingUserRecipes ? "Back" : "My Recipes"
        self.navigationItem.rightBarButtonItem?.title = myRecipeButtonTittle
        addButton?.isHidden = !isShowingUserRecipes
        
        if isShowingUserRecipes{
            self.loadingIndicator.stopAnimating()
            self.isLoading = false
            self.homeTableView.reloadSections(self.k.indexSet, with: .fade)
        }else{
            if !isLoaded{
                self.loadingIndicator.startAnimating()
                self.isLoading = true
            }
        }
        self.reload()
        homeTableView.reloadSections(k.indexSet, with: .fade)
    }
    @objc func addButtonTapped() {
        performSegue(withIdentifier: k.segueToAddMenu, sender: self)
    }
}
//MARK: - UITableViewDelegate
extension HomeScreenViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: k.segueToDetails, sender: self)
    }
    
}
//MARK: - UITableViewDataSource
extension HomeScreenViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading {
            return 0
        }
        
        let actualArray = isShowingUserRecipes ? (isOnSearch ? foundRecipes : userRecipes) : (isOnSearch ? foundRecipes : recipes)
        return actualArray.isEmpty ? 1 : actualArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let actualArray = isShowingUserRecipes ? (isOnSearch ? foundRecipes : userRecipes.reversed()) : (isOnSearch ? foundRecipes : recipes)
        let cellIdentifier = actualArray.isEmpty ? k.idErrorCell : k.idCell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HomeScreenCellController {
            let recipe = actualArray[indexPath.row]
            cell.recipe = recipe
            return cell
        }else if let errorCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NoRecipeTableViewCell {
            return errorCell
        }else{
            return  UITableViewCell()
        }
        
    }
    
}

//MARK: - RecipeManagerDelegate
extension HomeScreenViewController: RecipeManagerDelegate{
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
               // CoreDataManager.shared.insert(recipeId: newRecipe.id, isFavourite: false)//
            }else{
                self.recipeManager.getRecipes()
            }
            
            if self.recipes.count == self.k.recipesCount {
                self.loadingIndicator.stopAnimating()
                self.isLoading = false
                self.isLoaded = true
                self.homeTableView.reloadSections(self.k.indexSet, with: .fade)
                
                self.user.saveRecipesToUserDefaults(self.recipes)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
    
}
//MARK: - Navigation
extension HomeScreenViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == k.segueToDetails {
            if let destinationVC = segue.destination as? DetailViewController, let indexPath = homeTableView.indexPathForSelectedRow {
                let selectedRecipe:RecipeModel
                if isOnSearch {
                    selectedRecipe = foundRecipes[indexPath.row]
                } else {
                    selectedRecipe = isShowingUserRecipes ? userRecipes[indexPath.row] : recipes[indexPath.row]
                }
                toDetails.trnsferData(from: selectedRecipe, to: destinationVC)
            }
        }
        if segue.identifier == k.segueToAddMenu {
            if let addRecipeVC = segue.destination as? AddRecipeViewController {
                addRecipeVC.delegate = self
            }
        }
    }
}
//MARK: - UITextFieldDelegate
extension HomeScreenViewController:UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload), object: nil)
        if let searchText = searchTextField.text, !searchText.isEmpty {
            isOnSearch = true
            self.perform(#selector(reload), with: nil, afterDelay: 0.7)
        } else{
            isOnSearch = false
            foundRecipes.removeAll()
            homeTableView.reloadSections(k.indexSet, with: .fade)
        }
    }
    @objc func reload() {
        guard let name = searchTextField.text else { return }
        if isShowingUserRecipes {
            foundRecipes = searcManager.search(recipe: name, in: userRecipes)
        } else {
            foundRecipes = searcManager.search(recipe: name, in: recipes)
        }
        homeTableView.reloadSections(k.indexSet, with: .fade)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension HomeScreenViewController: UpdateUserRecipesCellsDelegate{
    func didAddRecipe() {
        loadUserRecipes()
    }
}
