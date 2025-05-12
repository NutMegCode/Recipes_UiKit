//
//  ViewController.swift
//  New Recipe
//
//  Created by Meg on 28/2/2025.
//

import UIKit
import Foundation

class NewRecipeViewController: UIViewController {
    
    // The new recipe screen allows a user to add a new recipe to the app
    // Current functionality should include the following features:
    // ability to add a recipe name, serves, description, and method
    // ability to add a number of ingredients with their title, uom, and quantity
    // a button to save the entered information as a Recipe to the recipe and favourites list as required
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var servesField: UITextField!
    
    @IBOutlet weak var methodTextView: UITextView!
    
    @IBOutlet weak var favouriteImage: UIImageView!
    
    @IBOutlet weak var ingredientTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ingredientsTable: UITableView!
    
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    
    var index: Int? = nil
    
    var recipeList: [Recipe] = []
    
    var recipe: Recipe = Recipe()
    
    var favourites: Favourites? = nil
    
    var isFavourite = false
    
    let rowHight = 60
    
    var rows = 1
    
    // for handling the keyboard so we don't block the user from the save button
    private var keyboardSize: CGRect = CGRect(x: 0, y: 0,
                                              width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the initial display
        favouriteImage.image = (recipe.isFavourite) ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        setupTable()
        
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.borderWidth = 0.5
        
        methodTextView.layer.borderColor = UIColor.lightGray.cgColor
        methodTextView.layer.borderWidth = 0.5
        
        servesField.layer.borderColor = UIColor.lightGray.cgColor
        servesField.layer.borderWidth = 0.5
        
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 0.5
        
        //handle the keyboard
        setDismissKeyboard()
        subscribeToKeyboard()
        
        // Register this VC for global error alerts - this will display an error if the user attempts to save a recipe with faulty data (a string as a number) or no data at all
        ErrorHandler.shared.presentingViewController = self

    }
    
    
    // set up the table, registering the cells it will use
    let ingredientCellIdentifier = "NewIngredientCell"

    private func setupTable() {
        
        let ingredientCellNib = UINib(nibName: ingredientCellIdentifier, bundle: nil)
        ingredientsTable.register(ingredientCellNib, forCellReuseIdentifier: ingredientCellIdentifier)
        
        ingredientTableHeight.constant = CGFloat(rowHight * (rows))
        
    }
    
    // a button to add another ingredient cell that can then be filled in
    @IBAction func addIngredientPressed(_ sender: Any) {
        
        rows += 1
        
        ingredientTableHeight.constant = CGFloat(rowHight * (rows))
        
        ingredientsTable.reloadData()
        
    }
    
    // a button to flag this recipe as a favourite or not
    @IBAction func favouriteButtonPressed(_ sender: Any) {

        isFavourite.toggle()
        
        favouriteImage.image = isFavourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
    
    // a button to save this recipe to the recipe list, and the favourites list if it is one, and then pop back to the dashboard where the new recipe will be displayed
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        recipe.name = titleTextField.text ?? ""
        recipe.description = descriptionTextView.text ?? ""
        recipe.serves = getStringToDouble(servesField.text) // if you put something that can't become a Double here, it'll be caught and set to nil
        recipe.ingredients = []
        
        // collect the data from the ingredients table, create Ingredients objects from them, and add to the recipies ingredients list
        for index in 0...rows-1 {
            
            if let cell = ingredientsTable.cellForRow(at: IndexPath(row: index, section: 0)) as? NewIngredientCell{
                
                if let ingredient = cell.getIngredient() {
                    
                    ingredient.quantityPerOneServe = ingredient.getQuantityOfOneForServes(Decimal(recipe.serves ?? 0))
                    
                    recipe.ingredients.append(ingredient)
                }
            }
        }
        
        recipe.method = methodTextView.text ?? ""
        
        recipe.isFavourite = isFavourite
        
        //if they didn't actually add anything just do nothing
        if !recipe.isEmpty() {
            recipeList.append(recipe)
            
            //we want to actually apply the changes to the recipe and favourites files
            if recipe.isFavourite {
                favourites?.addToFavourites(recipe)
            }
            
            FavouritesStorage().saveFavorites(favourites)
            
            RecipeStorage().saveRecipes(recipeList)
        }
        
        // pop back to the dashboard
        NavigationHelper.popViewController(from: self)
    }
    
}

// make sure you can tap outside of the view to dismiss the keyboard so the user does not get stuck with the keyboard blocking the save button or other fields
extension NewRecipeViewController{
    func setDismissKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(NewRecipeViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

// code for the Ingredients table
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

// follow the keyboards showing status so we can handle the closing of the keyboard
extension NewRecipeViewController {
    
    private func subscribeToKeyboard() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
            
        print("Keyboard will show")
                
        keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                
        UIView.animate(withDuration: 0.5, animations: {
            
            self.bottomSpace.constant = (self.keyboardSize.height - 40)
            
            self.view.layoutIfNeeded()
            
        })
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        print("Keyboard will hide")

        UIView.animate(withDuration: 0.5, animations: {
            
            self.bottomSpace.constant = 0
            
            self.view.layoutIfNeeded()
        })
    }

}
