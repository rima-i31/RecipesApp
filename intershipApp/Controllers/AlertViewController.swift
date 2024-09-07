//
//  AlertViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 07.09.2024.
//

import UIKit

protocol CustomAlertDelegate: AnyObject {
    func alertAction(_ controller: AlertViewController, didPressButton actionType: AlertActionType, forRecipeId recipeId: String)
}
enum AlertActionType {
    case add
    case remove
    case cancel
    case unknown
}

class AlertViewController: UIViewController {
    
    @IBOutlet weak var alertTitle: UILabel!
    
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    weak var delegate: CustomAlertDelegate?
        var actionType: AlertActionType?
        var recipeId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func noButtonTapped(_ sender: UIButton) {
        guard let recipeId = recipeId else { return }
        delegate?.alertAction(self, didPressButton: .cancel, forRecipeId: recipeId)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesButtonTapped(_ sender: UIButton) {
        guard let actionType = actionType, let recipeId = recipeId else { return }
        delegate?.alertAction(self, didPressButton: actionType, forRecipeId: recipeId)
        dismiss(animated: true, completion: nil)
    }
}
