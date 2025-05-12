//
//  Navigator.swift
//  Recipes
//
//  Created by Meg on 8/4/2025.
//

import UIKit

// a class to centralize navigation between VCs
class NavigationHelper {
    
    // navigate to the Recipe view
    static func goToRecipeView(from viewController: UIViewController, indexPath: IndexPath, recipeList: [Recipe], favourites: Favourites?) {
        let recipeStoryboard = UIStoryboard(name: "Recipe", bundle: nil)
        guard let recipeViewController = recipeStoryboard.instantiateViewController(withIdentifier: "Recipe") as? RecipeViewController else {
            ErrorHandler.shared.showError(message: "Unable to instantiate RecipeViewController from Recipe storyboard")
            return
        }
        
        // pass in all the details we need
        recipeViewController.index = indexPath.row
        recipeViewController.recipeList = recipeList
        recipeViewController.favourites = favourites
        
        viewController.navigationController?.pushViewController(recipeViewController, animated: true)
    }
    
    // navigate to the New Recipe screen
    static func goToNewRecipeView(from viewController: UIViewController, recipeList: [Recipe], favourites: Favourites?) {
        let newRecipeStoryboard = UIStoryboard(name: "NewRecipe", bundle: nil)
        guard let newRecipeViewController = newRecipeStoryboard.instantiateViewController(withIdentifier: "NewRecipe") as? NewRecipeViewController else {
            ErrorHandler.shared.showError(message: "Unable to instantiate RecipeViewController from Recipe storyboard")
            return
        }
        
        // pass in all the details we need

        newRecipeViewController.recipeList = recipeList
        newRecipeViewController.favourites = favourites
        
        viewController.navigationController?.pushViewController(newRecipeViewController, animated: true)
    }
    
    // handle popping the view controller to the previous VC in the stack
    static func popViewController(from viewController: UIViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
}
