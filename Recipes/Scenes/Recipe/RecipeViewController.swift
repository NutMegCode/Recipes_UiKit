//
//  ViewController.swift
//  Recipes
//
//  Created by Meg on 28/2/2025.
//

import UIKit
import Foundation

class RecipeViewController: UIViewController {
    
    // The recipe screen allows a user to view the detials of a recipe, change its favourite status, and change the number of serves they wish to see
    // Current functionality should include the following features:
    // ability to view all recipe details including name, description, method, serves and all ingredients qty, uom, and titles
    // a button to toggle the recipes favourite status
    // a textfield to modify the desired serves
    // a button to recalculate all the ingredients quantities for the new desired serves
    // a button to save the changes to the favourites status and the desired serves
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var servesField: UITextField!
    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var methodLabel: UILabel!
    
    @IBOutlet weak var favouriteImage: UIImageView!
    
    @IBOutlet weak var ingredientTableHeight: NSLayoutConstraint!
    
    var index: Int? = nil
    
    var recipeList: [Recipe] = []
    
    var recipe: Recipe? = nil
    
    var favourites: Favourites? = nil
    
    var isFavourite = false
    
    let rowHight = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the display populating the UI with the selected recipes details
        recipe = recipeList[index ?? 0]
        
        titleLabel.text = recipe?.name ?? "-"
        descriptionLabel.text = recipe?.description ?? "-"
        methodLabel.text = recipe?.method ?? "-"
        servesField.text = getDoubleToString(recipe?.serves)
        
        favouriteImage.image = (recipe?.isFavourite ?? false) ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        setupTable()

    }
    
    // set up the table, registering the cells it will use
    let ingredientCellIdentifier = "IngredientCell"

    private func setupTable() {
        
        let ingredientCellNib = UINib(nibName: ingredientCellIdentifier, bundle: nil)
        ingredientsTable.register(ingredientCellNib, forCellReuseIdentifier: ingredientCellIdentifier)
        
        ingredientTableHeight.constant = CGFloat(rowHight * (recipe?.ingredients.count ?? 0))
        
    }
    

    // a button to recalculate the ingredients quantites with the new desired serves, updating the UI to reflect the new quantities
    @IBAction func recalculateIngredientQuantities(_ sender: Any) {
        
        if let ingredientsList = recipe?.ingredients,
           let servesDouble = Double(servesField.text ?? "0"),
           let floatServes = Float(servesField.text ?? "0"){
            
            let decimalServes = Decimal(servesDouble)
            
            for ingredient in ingredientsList {
                if let quantityPerOneServe = ingredient?.quantityPerOneServe {
                    
                    //this stuff should demonstrate the different precisions of each data type. becuase Swift uses the IEEE standard there can be some imprecision with certain numbers
                    //to best demonstrate the imprecision create a recipe with 1 serve and an item with 0.1 quantity. then after saving recalculate with 0.2 serves.
                    // you would expect the result to be 0.02000000000
                    let doubleResult = NSDecimalNumber(decimal: quantityPerOneServe).doubleValue * servesDouble
                    debugPrint("Double result   \(ingredient?.name ?? ""):\(String(format: "%.20f", doubleResult))")
                    
                    let floatResult = NSDecimalNumber(decimal: quantityPerOneServe).floatValue * floatServes
                    debugPrint("Float result    \(ingredient?.name ?? ""): \(String(format: "%.20f", floatResult))")
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.minimumFractionDigits = 20
                    formatter.maximumFractionDigits = 20
                    
                    let decimalResult = quantityPerOneServe * decimalServes
                    if let formattedDecimal = formatter.string(from: decimalResult as NSDecimalNumber) {
                        debugPrint("Decimal result  \(ingredient?.name ?? ""): \(formattedDecimal)")
                    }
                    
                    debugPrint("==============================")
                    
                    ingredient?.quantity = doubleResult // acutally just use the Double result, its accurate enough for our purposes without costing much for storage
                    
                }
            }
        }
        
        ingredientsTable.reloadData()
    }
    
    // a button to toggle the recipes favourites status - this cuases a memory leak and hard reference whenever the .removeFromFavourites() and .addToFavourites() is called
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        if let recipe = recipe {
            if recipe.isFavourite {
                favourites?.removeFromFavourites(recipe)
            }else{
                favourites?.addToFavourites(recipe)
            }
                                    
            favouriteImage.image = recipe.isFavourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")

        }
        
    }
    
    // a button to save changes to the recipes favourites status and desired serves and return to the dashboard
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        //we want to actually apply the changes to the recipe and favourites files
        FavouritesStorage().saveFavorites(favourites)
        
        recipe?.serves = getStringToDouble(servesField.text ?? "0") ?? 0
        RecipeStorage().saveRecipes(recipeList)
        
        NavigationHelper.popViewController(from: self)
        
    }
    
    // a button to delete the recipe from the recipe list and favourites list if applicable
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        if let recipe = recipe {
            if recipe.isFavourite {
                favourites?.removeFromFavourites(recipe)
            }
            
            if let index = index{
                recipeList.remove(at: index)
            }
            
            FavouritesStorage().saveFavorites(favourites)
            
            RecipeStorage().saveRecipes(recipeList)
            
            //then pop the VC back to dashboard
            guard let navigationController = navigationController else {
                fatalError("Navigation controller not found")
            }
            
            navigationController.popViewController(animated: true)

        }
        
    }
    
}

// if we want to be fancy with the textfield, do it here
extension RecipeViewController: UITextFieldDelegate {
    
    
    
}

// code for the Ingredients table
extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ingredientCellIdentifier, for: indexPath) as? IngredientCell
        
        let ingredients = recipe?.ingredients
        
        if  let cell,
            let ingredients,
            ingredients.count > indexPath.row {
            
            if let ingredient = ingredients[indexPath.row]{
                
                cell.setIngredient(ingredient: ingredient)
            } else {
                debugPrint("Error: with the ingredient Cell")
                return UITableViewCell()
            }
                        
            return cell
            
        } else {
            debugPrint("Error: with the ingredient Cell")
            return UITableViewCell()
        }

        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHight)
    }

}

