//
//  ViewController.swift
//  Paradigm Project
//
//  Created by Meg on 28/2/2025.
//

import UIKit
import Foundation

class NewRecipeViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var servesField: UITextField!
    
    @IBOutlet weak var methodTextView: UITextView!
    
    @IBOutlet weak var favouriteImage: UIImageView!
    
    @IBOutlet weak var ingredientTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ingredientsTable: UITableView!
    
    var index: Int? = nil
    
    var recipeList: [Recipe] = []
    
    var recipe: Recipe = Recipe()
    
    var favourites: Favourites? = nil
    
    var isFavourite = false
    
    let rowHight = 80
    
    var rows = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favouriteImage.image = (recipe.isFavourite) ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        setupTable()

    }
    
    let ingredientCellIdentifier = "NewIngredientCell"

    private func setupTable() {
        
        let ingredientCellNib = UINib(nibName: ingredientCellIdentifier, bundle: nil)
        ingredientsTable.register(ingredientCellNib, forCellReuseIdentifier: ingredientCellIdentifier)
        
        ingredientTableHeight.constant = CGFloat(rowHight * (rows))
        
    }
    
    @IBAction func addIngredientPressed(_ sender: Any) {
        
        rows += 1
        
        ingredientTableHeight.constant = CGFloat(rowHight * (rows))
        
        ingredientsTable.reloadData()
        
    }
    
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {

        isFavourite.toggle()
        
        favouriteImage.image = isFavourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        recipe.name = titleTextField.text ?? ""
        recipe.description = descriptionTextView.text ?? ""
        recipe.serves = Double(servesField.text ?? "0")
        recipe.ingredients = []
        
        for index in 0...rows-1 {
            
            if let cell = ingredientsTable.cellForRow(at: IndexPath(row: index, section: 0)) as? NewIngredientCell{
                
                recipe.ingredients.append(cell.getIngredient())
            }
        }
        
        recipe.method = methodTextView.text ?? ""
        
        recipe.isFavourite = isFavourite
        
        recipeList.append(recipe)

        
        //we want to actually apply the changes to the recipe and favourites files
        
        if recipe.isFavourite {
            favourites?.addToFavourites(recipe)
        }
        
        FavouritesStorage().saveFavorites(favourites)
        
        RecipeStorage().saveRecipes(recipeList)
        
        //then pop the VC back to dashboard
        guard let navigationController = navigationController else {
            fatalError("Navigation controller not found")
        }// I need to create a centralised controller. this is just painful
        
        navigationController.popViewController(animated: true)
        
    }
    
}

extension NewRecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ingredientCellIdentifier, for: indexPath) as? NewIngredientCell
        
        if let cell{

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

