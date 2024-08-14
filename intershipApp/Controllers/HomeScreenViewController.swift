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
    var recipes: [RecipeModel] = []
    var foundRecipes: [RecipeModel] = []
    var searcManager = SearchManager()
    var recipeManager = RecipeManager()
    var toDetails = ToDetailsSegueManager()
    var isOnSearch:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let i = UIScreen.main.nativeScale
        print(i)
        self.navigationItem.title = "Recipes"
        
        self.navigationItem.hidesBackButton = true
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        
        homeTableView.register(UINib(nibName: k.idCell, bundle: nil), forCellReuseIdentifier: k.idCell)
        homeTableView.register(UINib(nibName: k.idErrorCell, bundle: nil), forCellReuseIdentifier: k.idErrorCell)
        
        setupLoadingIndicator()
        recipeManager.delegate = self
        loadingIndicator.startAnimating()
        loadRandomRecipes()
        searchTextField.delegate = self
        
        
    }
    func loadRandomRecipes() {
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
        let foundCellsCount = foundRecipes.isEmpty ? 1 : foundRecipes.count
        return isOnSearch ? foundCellsCount : recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let actualArray = isOnSearch ? foundRecipes : recipes
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
            }else{
                self.recipeManager.getRecipes()
            }
            
            if self.recipes.count == self.k.recipesCount {
                self.loadingIndicator.stopAnimating()
                self.homeTableView.reloadSections(self.k.indexSet, with: .fade)
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
                    selectedRecipe = recipes[indexPath.row]
                }
                toDetails.trnsferData(from: selectedRecipe, to: destinationVC)
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
        foundRecipes = searcManager.search(recipe: name, in: recipes)
        
        homeTableView.reloadSections(k.indexSet, with: .fade)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
