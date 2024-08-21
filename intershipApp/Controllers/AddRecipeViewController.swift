//
//  AddRecipeViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 19.08.2024.
//

import UIKit

class AddRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var addRecipeTable: UITableView!
    
    var k = K()
    var imagePath: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        addRecipeTable.delegate = self
        addRecipeTable.dataSource = self
        addRecipeTable.register(UINib(nibName: k.addRecipeCell, bundle: nil), forCellReuseIdentifier: k.addRecipeCell)
       
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.k.addRecipeCell, for: indexPath) as? AddCellTableViewCell {
            return cell
        }else{
            return UITableViewCell()
        }
    }
}
/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
