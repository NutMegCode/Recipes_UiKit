//
//  ViewController.swift
//  Paradigm Project
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var servesField: UITextField!
    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var methodLabel: UILabel!
    
    @IBOutlet weak var favouriteImage: UIImageView!
    
    @IBOutlet weak var ingredientTableHeight: NSLayoutConstraint!
    
    var recipe: Recipe? = nil
    
    var favourites: Favourites? = nil
    
    var isFavourite = false
    
    let rowHight = 50
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = recipe?.name ?? "-"
        descriptionLabel.text = recipe?.description ?? "-"
        methodLabel.text = recipe?.method ?? "-"
        servesField.text = "\(recipe?.serves ?? 0)"
        
        favouriteImage.image = (recipe?.isFavourite ?? false) ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        setupTable()

    }
    
    let ingredientCellIdentifier = "IngredientCell"

    private func setupTable() {
        
        let ingredientCellNib = UINib(nibName: ingredientCellIdentifier, bundle: nil)
        ingredientsTable.register(ingredientCellNib, forCellReuseIdentifier: ingredientCellIdentifier)
        
        ingredientTableHeight.constant = CGFloat(rowHight * (recipe?.ingredients.count ?? 0))
        
    }
    
    @IBAction func recalculateAsFloat(_ sender: Any) {
        
        if let ingredientsList = recipe?.ingredients,
           let serves = Double(servesField.text ?? "0"){
            
            for ingredient in ingredientsList {
                if let quantityPerOneServe = ingredient?.quantityPerOneServe {
                    ingredient?.quantity = quantityPerOneServe * serves
                }
            }
        }
        
        ingredientsTable.reloadData()
    }
    
    @IBAction func recalculateAsFDouble(_ sender: Any) {
        
        if let ingredientsList = recipe?.ingredients,
           let serves = Float(servesField.text ?? "0"){
            
            for ingredient in ingredientsList {
                if let quantityPerOneServe = ingredient?.quantityPerOneServe {
                    ingredient?.quantity = Double(Float(quantityPerOneServe) * serves)
                }

            }
            
        }
        
        ingredientsTable.reloadData()
    }
    
    
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
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        //we want to actually apply the changes to the recipe and favourites files
        
        //then pop the VC back to dashboard
        guard let navigationController = navigationController else {
            fatalError("Navigation controller not found")
        }// I need to create a centralised controller. this is just painful
        
        navigationController.popViewController(animated: true)
        
    }
    
}

extension RecipeViewController: UITextFieldDelegate {
    
    
    
}

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

