//
//  HomeScreenViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 05.08.2024.
//

import UIKit
extension Notification.Name {
    static let startedSwipe = Notification.Name("startedSwipe")
}
class HomeScreenCellController: UITableViewCell {
    
    @IBOutlet weak var meelImage: UIImageView!
    
    @IBOutlet weak var meelName: UILabel!
    
    
    @IBOutlet weak var ingredients: UILabel!
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var toFavButton: UIButton!
    
    @IBOutlet weak var toFavSlideBut: UIButton!
    
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    var cellID = UUID().uuidString
    
    var isFavorite = false
    var recipe: RecipeModel? {
        
        didSet {
            guard let data = recipe else { return }
            rightConstraint.constant = 15
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
    override func awakeFromNib() {
        super.awakeFromNib()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
        
        NotificationCenter.default.addObserver(self, selector: #selector(favouritesDidUpdate(_:)), name: .favouritesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeSwipes(_:)), name: .startedSwipe, object: nil)
        
    }
    @objc private func closeSwipes(_ notification: Notification){
        guard let userInfo = notification.userInfo, let swipedCellID = userInfo["cellID"] as? String else { return }
        
        if swipedCellID != self.cellID {
            rightConstraint.constant = 15
            toFavSlideBut.isHidden = true
        }
    }
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        NotificationCenter.default.post(name: .startedSwipe, object: nil, userInfo: ["cellID": self.cellID])
        toFavSlideBut.isHidden = false
        switch gesture.direction {
        case .left:
            rightConstraint.constant = 115
            
        case .right:
            rightConstraint.constant = 15
        default:
            break
        }
        cellReloadStatus()
    }
    func cellReloadStatus(){
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func toFavSlideButTapped(_ sender: UIButton) {
        guard let recipeID = recipe?.id, let isLocalRecipe = recipe?.isLocal else { return }
        let isCurrentlyFavorite = CoreDataManager.shared.isFavouriteRecipe(id: recipeID)
        
        if !isCurrentlyFavorite {
            
            setFavoriteState()
            CoreDataManager.shared.addFavourite(recipeId: recipeID, isLocal: isLocalRecipe)
            CoreDataManager.shared.printAllRecipesFromCoreData()
        } else {
            presentRemoveFavoriteAlert(recipeID: recipeID)            }
        
        CoreDataManager.shared.printAllRecipesFromCoreData()
    }
    private func presentRemoveFavoriteAlert(recipeID: String) {
        guard let viewController = self.parentViewController else { return }
        
        let alert = UIAlertController(title: "Remove from Favorites?",
                                      message: "Are you sure you want to remove this recipe from your favorites?",
                                      preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
            self.setUnfavoriteState()
            CoreDataManager.shared.deleteFavourite(recipeId: recipeID)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){_ in
            self.rightConstraint.constant = 15
            self.toFavSlideBut.isHidden = true
            self.cellReloadStatus()
        }
        
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    private func setFavoriteState() {
        toFavButton.tintColor = .yellow
        toFavButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
        rightConstraint.constant = 15
        cellReloadStatus()
        toFavSlideBut.setImage(UIImage(systemName: "star.slash"), for: .normal)
        toFavSlideBut.backgroundColor = UIColor(named: "deleteColor")
        toFavSlideBut.isHidden = true
    }
    
    private func setUnfavoriteState() {
        toFavButton.tintColor = .gray
        toFavButton.setImage(UIImage(systemName: "star"), for: .normal)
        
        rightConstraint.constant = 15
        cellReloadStatus()
        toFavSlideBut.setImage(UIImage(systemName: "star"), for: .normal)
        toFavSlideBut.backgroundColor = .yellow
        toFavSlideBut.isHidden = true
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favouritesUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: .startedSwipe, object: nil)
    }
    @objc private func favouritesDidUpdate(_ notification: Notification) {
        guard let recipeID = recipe?.id else { return }
        if CoreDataManager.shared.isFavouriteRecipe(id: recipeID) {
            setFavoriteState()
        } else {
            setUnfavoriteState()
        }
    }
}
