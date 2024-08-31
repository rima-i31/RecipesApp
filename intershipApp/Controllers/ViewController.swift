//
//  ViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 03.08.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            clearUserDefaults()
//        }
//
//        func clearUserDefaults() {
//            let defaults = UserDefaults.standard
//            if let appDomain = Bundle.main.bundleIdentifier {
//                defaults.removePersistentDomain(forName: appDomain)
//            }
//            defaults.synchronize()
//        }

}

