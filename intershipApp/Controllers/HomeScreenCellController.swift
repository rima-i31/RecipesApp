//
//  HomeScreenViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 05.08.2024.
//

import UIKit

class HomeScreenCellController: UITableViewCell {
    
    @IBOutlet weak var meelImage: UIImageView!
    
    @IBOutlet weak var meelName: UILabel!
    
    
    @IBOutlet weak var ingredients: UILabel!
    
    var recipe:RecipeModel? {
        didSet {
            guard let data = self.recipe else {return}
            self.meelName.text = data.mealName
            self.ingredients.text = data.ingredients
            //            if let imageUrl = URL(string: data.imageSrc) {
            //                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            //                    if let safeData = data, error == nil {
            //                        DispatchQueue.main.async {
            //                            self.meelImage.image = UIImage(data: safeData)
            //                        }
            //                    }
            //                }.resume()
            //            }
            if let imageUrl = URL(string: data.imageSrc) {
                let urlString = data.imageSrc
                if let cachedImage = ImageCache.shared.getImage(forKey: urlString) {
                    self.meelImage.image = cachedImage
                  
                } else {
                    URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                        if let safeData = data, error == nil, let image = UIImage(data: safeData) {
                            let resizedImage = ImageCache.shared.resizeImage(image: image)
                            ImageCache.shared.setImage(resizedImage, forKey: urlString)
                            DispatchQueue.main.async {
                                self.meelImage.image = resizedImage
                              
                            }
                        }
                    }.resume()
                }
            }
        }
    }
}
