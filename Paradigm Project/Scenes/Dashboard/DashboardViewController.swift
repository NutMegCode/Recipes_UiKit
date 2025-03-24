//
//  DashboardViewController.swift
//  Paradigm Project
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var recipeTable: UITableView!
    @IBOutlet weak var filterFavouritesImage: UIImageView!
    
    var recipeList: [Recipe] = []
    
    var favourites: Favourites? = nil
    
    var filtered = false
    
    let importer = RecipeImporter()
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        favourites = FavouritesStorage().loadFavourites()
        
        recipeList = RecipeStorage().loadRecipes()
        
        recipeTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        
        filterFavouritesImage.image = filtered ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
    }
    
    let recipeCellIdentifier = "RecipeCell"

    private func setupTable() {
        
        let recipeCellNib = UINib(nibName: recipeCellIdentifier, bundle: nil)
        recipeTable.register(recipeCellNib, forCellReuseIdentifier: recipeCellIdentifier)
        
    }
    
    
    @IBAction func addNewPressed(_ sender: Any) {
        
                
        let newRecipeStoryboard = UIStoryboard(name: "NewRecipe", bundle: nil)
        
        // Instantiate the view controller from the second storyboard
        guard let newRecipeViewController = newRecipeStoryboard.instantiateViewController(withIdentifier: "NewRecipe") as? NewRecipeViewController else {
            fatalError("Unable to instantiate NewRecipeViewController from NewRecipeStoryboard")
        }
        
        guard let navigationController = navigationController else {
            fatalError("Navigation controller not found")
        }
                
        newRecipeViewController.recipeList = recipeList
        
        newRecipeViewController.favourites = favourites
        
        // Push or present the second view controller
        navigationController.pushViewController(newRecipeViewController, animated: true)
        
    }
    
    
    @IBAction func filterFavouritePressed(_ sender: Any) {
        
        filtered.toggle()
        recipeTable.reloadData()
        
        filterFavouritesImage.image = filtered ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")

    }
    
    @IBAction func importButtonPressed(_ sender: Any) {
        
        importer.onRecipesImported = { [weak self] newRecipes in //weak self here is easily missed, but prevents a hard reference retain cycle causing memory leaks
            
            guard let self = self else { return }
            
            self.recipeList.append(contentsOf: newRecipes)
            self.favourites?.favourites = recipeList.filter { $0.isFavourite }
            RecipeStorage().saveRecipes(recipeList)
            FavouritesStorage().saveFavorites(favourites)
            self.recipeTable.reloadData()
            
        }
        
        importer.importRecipes(from: self)
        
    }
    
    @IBAction func exportButtonPressed(_ sender: Any) {
        let exporter = RecipeExporter()
        exporter.exportRecipes(recipeList, from: self)
    }
    
    
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let recipeCount = filtered ? recipeList.filter { $0.isFavourite }.count : recipeList.count
        
        return recipeCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: recipeCellIdentifier, for: indexPath) as? RecipeCell
        
        let recipes = filtered ? recipeList.filter { $0.isFavourite } : recipeList
        
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
        
        let recipes = filtered ? recipeList.filter { $0.isFavourite } : recipeList

        if recipes.count > indexPath.row{
            
            let secondStoryboard = UIStoryboard(name: "Recipe", bundle: nil)
            
            // Instantiate the view controller from the second storyboard
            guard let secondViewController = secondStoryboard.instantiateViewController(withIdentifier: "Recipe") as? RecipeViewController else {
                fatalError("Unable to instantiate SecondViewController from SecondStoryboard")
            }
            
            guard let navigationController = navigationController else {
                fatalError("Navigation controller not found")
            }
            
            secondViewController.index = indexPath.row
            
            secondViewController.recipeList = recipeList
            
            secondViewController.favourites = favourites
            
            // Push or present the second view controller
            navigationController.pushViewController(secondViewController, animated: true)
            
        }
        
    }
    
}
