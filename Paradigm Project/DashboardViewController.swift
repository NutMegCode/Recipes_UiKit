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
        

        let recipe = Recipe()
        let ingredient = Ingredient()
        
        ingredient.name = "Test Ingredient"
        ingredient.quantity = 1
        ingredient.uom = "kg"
        
        recipe.name = "Test Recipe"
        recipe.description = "This is a test recipe"
        recipe.serves = 2
        ingredient.quantityPerOneServe = ingredient.getQuantityOfOneForServes(recipe.serves)
        recipe.ingredients = [ingredient]
        recipe.method = "This is an example method"
        recipe.favourites = Favourites()
        
        secondViewController.recipe = recipe
        
        // Push or present the second view controller
        navigationController.pushViewController(secondViewController, animated: true)
        
    }
    
    
}
