//
//  DashboardViewController.swift
//  Paradigm Project
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class DashboardViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
    }
    

    @IBAction func transitionButton(_ sender: Any) {
        let secondStoryboard = UIStoryboard(name: "Recipe", bundle: nil)
        
        // Instantiate the view controller from the second storyboard
        guard let secondViewController = secondStoryboard.instantiateViewController(withIdentifier: "Recipe") as? RecipeViewController else {
            fatalError("Unable to instantiate SecondViewController from SecondStoryboard")
        }
        
        guard let navigationController = navigationController else {
            fatalError("Navigation controller not found")
        }
        
        // Push or present the second view controller
        navigationController.pushViewController(secondViewController, animated: true)
        
    }
    
    
}
