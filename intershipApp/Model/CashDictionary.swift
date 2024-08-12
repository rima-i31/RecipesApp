//
//  CashDictionary.swift
//  intershipApp
//
//  Created by Rima Mihova on 12.08.2024.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private var cache = [String: UIImage]()
    
    private init() {}
    
    func getImage(forKey key: String) -> UIImage? {
        return cache[key]
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache[key] = image
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let targetSize = getTargetSize()
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    private func getTargetSize() -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        
        switch screenHeight {
        case 0..<667:
            return CGSize(width: 100, height: 100)
        case 667..<896:
            return CGSize(width: 120, height: 120)
        default: 
            return CGSize(width: 150, height: 150)
        }
    }
}


