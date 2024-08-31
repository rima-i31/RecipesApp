//
//  TabBarController.swift
//  intershipApp
//
//  Created by Rima Mihova on 28.08.2024.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var addButton: UIBarButtonItem?
    var toggleSearch: UIBarButtonItem?
    var toggleFav: UIBarButtonItem?
    var k = K()
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        toggleSearch = UIBarButtonItem(title: "My Recipes" ,style: .plain, target: self, action: #selector(toggleButtonTapped))
        toggleFav = UIBarButtonItem(title: "My Recipes" ,style: .plain, target: self, action: #selector(toggleFavButtonTapped))
        self.delegate = self
        updateNavigationBar(for: selectedIndex)
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(handleMemoryWarning),
                   name: UIApplication.didReceiveMemoryWarningNotification,
                   object: nil
               )
        
        
    }
    @objc func toggleButtonTapped() {
           if let searchVC = viewControllers?[3] as? SearchViewController {
               searchVC.toggleButtonTapped()
           }
       }
    @objc func toggleFavButtonTapped() {
           if let favVC = viewControllers?[2] as? FavouritsViewController {
               favVC.toggleFavButtonTapped()
           }
       }
    @objc func addButtonTapped() {
        performSegue(withIdentifier: k.segueToAddMenu, sender: self)
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
           updateNavigationBar(for: selectedIndex)
       }
    private func updateNavigationBar(for index: Int) {
        navigationItem.hidesBackButton = true
                navigationItem.leftBarButtonItems = nil
                navigationItem.rightBarButtonItems = nil
                
                switch index {
                case 0:
                    self.navigationItem.title = "Recipes"
                    addButton?.isHidden = true
                    navigationItem.rightBarButtonItem = nil
                case 1:
                    self.navigationItem.title = "My Recipes"
                    navigationItem.rightBarButtonItem = addButton
                    addButton?.isHidden = false
                case 2:
                    self.navigationItem.title = "Favorites"
                    navigationItem.rightBarButtonItem = toggleFav
                    toggleFav?.isHidden = false
                case 3:
                    self.navigationItem.title = "Search"
                    navigationItem.rightBarButtonItem = toggleSearch
                    toggleSearch?.isHidden = false
                default:
                    self.navigationItem.title = "Recipes"
                    navigationItem.rightBarButtonItem = nil
                }
      }

    @objc func handleMemoryWarning() {
        let defaults = UserDefaults.standard
        if let appDomain = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: appDomain)
        }
        defaults.synchronize()
        navigationController?.popToRootViewController(animated: true)
        //print(self.navigationController?.viewControllers)
       }

}
