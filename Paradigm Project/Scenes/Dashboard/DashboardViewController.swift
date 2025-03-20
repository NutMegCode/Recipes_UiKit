//
//  DashboardViewController.swift
//  Paradigm Project
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var recipeTable: UITableView!
    
    var recipeList: [Recipe] = []
    
    var favourites: Favourites? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        
        //get recipes from memory
        let chickenJumble = Recipe()
        
        let chicken = Ingredient()
        chicken.name = "Chicken"
        chicken.quantity = 600
        chicken.uom = "g"
        
        let potatoes = Ingredient()
        potatoes.name = "Potatoes"
        potatoes.quantity = 4
        potatoes.uom = "each"
        
        let zuchini = Ingredient()
        zuchini.name = "Zuchini"
        zuchini.quantity = 1
        zuchini.uom = "each"
        
        let tomatoes = Ingredient()
        tomatoes.name = "Misc mini tomatoes"
        tomatoes.quantity = 1
        tomatoes.uom = "tub"
        
        chickenJumble.name = "Chicken Jumble"
        chickenJumble.description = "An easy oven dish you can chuck in the oven and forget about"
        chickenJumble.serves = 4
        
        chickenJumble.ingredients = [chicken, potatoes, zuchini, tomatoes]
        
        for ingredient in chickenJumble.ingredients {
            if let ingredient = ingredient{
                ingredient.quantityPerOneServe = ingredient.getQuantityOfOneForServes(chickenJumble.serves)
            }
        }
        
        chickenJumble.method = "1. peel potatoes, \n2. chop potatoes and zuchini into medium chunks \n3. fadd all ingredients to a deep oven dish lined with tin foil and baking paper \n4. season how you like \n5. drissle with generous olive oil \n6. toss gently until everything is seasoned well \n7. put in oven and bake for 40 minutes \n8. remove from oven and serve \n\n Note: if you left it for a while in the oven after done becuase you were busy, just turn the oven back on again for about 10 minutes to reheat before serving"
        chickenJumble.isFavourite = false
        
        recipeList.append(chickenJumble)
        
        let ricePudding = Recipe()
        
        let rice = Ingredient()
        rice.name = "rice"
        rice.quantity = 1
        rice.uom = "cup"
        
        let milk = Ingredient()
        milk.name = "milk"
        milk.quantity = 1
        milk.uom = "L"
        
        let sugar = Ingredient()
        sugar.name = "sugar"
        sugar.quantity = 1
        sugar.uom = "tbsp"
        
        let cinnamon = Ingredient()
        cinnamon.name = "cinnamon"
        cinnamon.quantity = 1
        cinnamon.uom = "tsp"
        
        let raisins = Ingredient()
        raisins.name = "raisins"
        raisins.quantity = 0.5
        raisins.uom = "handfull"
        
        ricePudding.ingredients = [rice, milk, sugar, cinnamon, raisins]
        
        ricePudding.name = "Rice Pudding"
        ricePudding.description = "A mostly healthy rice dessert. per serve it has less sugar than most people have in their coffees each morning. Creamy and yum!"
        ricePudding.serves = 2
        
        for ingredient in ricePudding.ingredients {
            if let ingredient = ingredient{
                ingredient.quantityPerOneServe = ingredient.getQuantityOfOneForServes(ricePudding.serves)
            }
        }
        
        ricePudding.method = "1. rinse your rice \n2. add to a pot with milk \n3. mix with milk, sugar, cinnamon and raisins \n4. simmer until milk has evaporated and rice is tender. stiring often to prevent burning or boiling over \n5. serve \n\n lasts 6 days in fridge"
        ricePudding.isFavourite = true
        
        recipeList.append(ricePudding)
        
        //get favourites from memory
        
        favourites = Favourites()
        favourites?.addToFavourites(ricePudding)
        
    }
    
    let recipeCellIdentifier = "RecipeCell"

    private func setupTable() {
        
        let recipeCellNib = UINib(nibName: recipeCellIdentifier, bundle: nil)
        recipeTable.register(recipeCellNib, forCellReuseIdentifier: recipeCellIdentifier)
        
    }
    
    
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: recipeCellIdentifier, for: indexPath) as? RecipeCell
        
        let recipes = recipeList
        
        if  let cell,
            recipes.count > indexPath.row {
            
            cell.setRecipe(recipe: recipes[indexPath.row])
            
            return cell
            
        } else {
            debugPrint("Error: with the ingredient Cell")
            return UITableViewCell()
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recipes = recipeList
        
        if recipes.count > indexPath.row{
            let recipe = recipes[indexPath.row]
            
            let secondStoryboard = UIStoryboard(name: "Recipe", bundle: nil)
            
            // Instantiate the view controller from the second storyboard
            guard let secondViewController = secondStoryboard.instantiateViewController(withIdentifier: "Recipe") as? RecipeViewController else {
                fatalError("Unable to instantiate SecondViewController from SecondStoryboard")
            }
            
            guard let navigationController = navigationController else {
                fatalError("Navigation controller not found")
            }
            
            secondViewController.recipe = recipe
            
            secondViewController.favourites = favourites
            
            // Push or present the second view controller
            navigationController.pushViewController(secondViewController, animated: true)
            
        }
        
    }
    
}
