//
//  AllRecipesViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 28.08.2024.
//

import UIKit

class AllRecipesViewController: UIViewController, RecipeManagerDelegate, iCarouselDataSource, iCarouselDelegate {
    
    
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    var k = K()
    var recipeManager = RecipeManager()
    var user = UserData()
    var recipes: [RecipeModel] = []
    
    var isLoaded:Bool = false
    var isShowingTable = true
    var recipesTableVC = RecipesTableViewController()
    
    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var carousel: iCarousel!
    
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
            setUpUI()
        } else {
            loadRandomRecipes()
        }
        recipesTableVC.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        
    }
    func setUpUI(){
        let switchButton = UIBarButtonItem(title: "Show Carousel", style: .plain, target: self, action: #selector(toggleView))
        navigationItem.rightBarButtonItem = switchButton
        setupScrollView()
        setupStackView()
        recipesTableVC.dataSource = recipes
        addChild(recipesTableVC)
        stackView.addArrangedSubview(recipesTableVC.view)
        recipesTableVC.didMove(toParent: self)
        carousel = setupCarousel()
        stackView.addArrangedSubview(carousel)
        scrollView.isScrollEnabled = false
        recipesTableVC.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        carousel.alpha = 0
    }
    func setupStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2)
        ])
    }
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func setupCarousel() -> iCarousel {
        let carousel = iCarousel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        carousel.dataSource = self
        carousel.delegate = self
        carousel.type = .rotary
        return carousel
    }
    @objc func toggleView() {
        isShowingTable.toggle()
        let newOffset = isShowingTable ? CGPoint(x: 0, y: 0) : CGPoint(x: scrollView.frame.width, y: 0)
        UIView.animate(withDuration: 0.3) {
            self.scrollView.setContentOffset(newOffset, animated: false)
        }
        UIView.animate(withDuration: 0.3) {
            self.carousel.alpha = self.isShowingTable ? 0 : 1
        }
        
        navigationItem.rightBarButtonItem?.title = isShowingTable ? "Show Carousel" : "Show Table"
    }
    func numberOfItems(in carousel: iCarousel) -> Int {
        return recipes.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIView
        let itemWidth = view?.frame.width ?? self.view.frame.width * 0.8
        let itemHeight = itemWidth
        
        if let view = view {
            itemView = view
        } else {
            itemView = UIView(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemHeight))
            itemView.backgroundColor = .clear
            let imageContainer = UIView(frame: itemView.bounds)
            imageContainer.contentMode = .scaleAspectFill
            imageContainer.clipsToBounds = true
            imageContainer.layer.cornerRadius = 20
            let imageView = UIImageView(frame: imageContainer.bounds)
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.center = imageView.center
            imageView.addSubview(activityIndicator)
            
            let recipeImageSrc = recipes[index].imageSrc
            ImageLoader.shared.loadImage(from: recipeImageSrc, into: imageView, with: activityIndicator)
            imageContainer.addSubview(imageView)
            itemView.addSubview(imageContainer)
            let label = UILabel(frame: CGRect(x: 0, y: imageContainer.frame.maxY - 50, width: imageContainer.frame.width, height: 50))
            label.text = recipes[index].mealName
            label.textAlignment = .center
            label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            label.textColor = .white
            imageContainer.addSubview(label)
        }
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        print("Выбран рецепт под индексом: \(index)")
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
                self.setUpUI()
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
