//
//  DashboardViewController.swift
//  Recipes
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // The dashboard is the landing screen once the app has loaded. It should display a list of Recipes if some have already been added
    // Current functionality should include the following features:
    // list of recipes already added
    // message to inform user if no recipes exist yet
    // a button to add a new recipe which will be displayed here once added
    // a button to filter the displayed recipes for if they are favourites or not
    // the ability to export the recipe list as a JSON file
    // the ability to import a JSON file containing Recipes to add them to the current recipe list
    
    // Future improvements could add
    // more control for the user in handling imported recipes
    // an option to sort the recipes by name
    // an option to rearange the order of recipes
    // grouped recipes
    
    @IBOutlet weak var recipeTable: UITableView!
    @IBOutlet weak var filterFavouritesImage: UIImageView!
    @IBOutlet weak var EmptyLabel: UILabel!
    
    var recipeList: [Recipe] = []
    
    var favourites: Favourites? = nil
    
    var filtered = false
    
    let importer = RecipeImporter()
    
    // This will fire before we first show the dashboard, or when we pop back to the dashboard
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        // refresh the favourites and recipe lists once popping back, we may have added something new, or something deleted
        favourites = FavouritesStorage().loadFavourites()
        recipeList = RecipeStorage().loadRecipes()
        
        // make it pretty in case we have poped back after deleting the last recipe
        handleEmptyView()
        recipeTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up the table, empty view, and favourites filter for our first load of the dashboard
        setupTable()
        handleEmptyView()
        filterFavouritesImage.image = filtered ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
    }
    
    // if we have no recipes saved display a view and text letting the user know
    private func handleEmptyView() {
        EmptyLabel.isHidden = (filtered ? recipeList.filter { $0.isFavourite }.count : recipeList.count) != 0 //its one line sure, but is it easy to read? ... no
        EmptyLabel.text = filtered ? "No favourite recipes" : "No recipes" //customise for favourites filtering
    }
    
    
    // set up the table, registering the cells it will use
    let recipeCellIdentifier = "RecipeCell"

    private func setupTable() {
        
        let recipeCellNib = UINib(nibName: recipeCellIdentifier, bundle: nil)
        recipeTable.register(recipeCellNib, forCellReuseIdentifier: recipeCellIdentifier)
        
    }
    
    
    // a button that transitions to the new Recipe screen
    @IBAction func addNewPressed(_ sender: Any) {
        
        NavigationHelper.goToNewRecipeView(from: self, recipeList: recipeList, favourites: favourites)
        
    }
    
    // a button that toggles the filtering of the favourites from the recipe list, updating the UI to reflect the selection
    @IBAction func filterFavouritePressed(_ sender: Any) {
        
        filtered.toggle()
        recipeTable.reloadData()
        
        filterFavouritesImage.image = filtered ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        handleEmptyView()

    }
    
    
    // a button that allows the user to import a JSON file containing Recipes and adds them to our table, updating the UI to reflect changes
    // TODO: add another step to check if the user wants to overwrite their current recipes, or add the imported recipes to the end of the current ones
    // TODO: add another step to allow the user to select specific recipes to add to their recipe list
    
    @IBAction func importButtonPressed(_ sender: Any) {
        
        importer.onRecipesImported = { [weak self] newRecipes in //weak self here is easily missed, but prevents a hard reference retain cycle causing memory leaks
            
            guard let self = self else { return }
            
            self.recipeList.append(contentsOf: newRecipes)
            self.favourites?.favourites = recipeList.filter { $0.isFavourite }
            RecipeStorage().saveRecipes(recipeList)
            FavouritesStorage().saveFavorites(favourites)
            EmptyLabel.isHidden = !recipeList.isEmpty
            self.recipeTable.reloadData()
            
        }
        
        importer.importRecipes(from: self)
        
    }
    
    
    // a button that allows the user to export their recipe list to a JSON file
    @IBAction func exportButtonPressed(_ sender: Any) {
        let exporter = RecipeExporter()
        exporter.exportRecipes(recipeList, from: self)
    }
    
    
}


//Table handling - this is different from what I am used to in Kotlin, having the table seperate rather than as part of the main body
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
            recipes.count > indexPath.row { // make sure we have something
            
            cell.setRecipe(recipe: recipes[indexPath.row])
            
            return cell
            
        } else { // handle it if we don't have a cell. This is a similar syntax to the do catch of error handling and is effectively the same outcome
            debugPrint("Error: with the ingredient Cell")
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //when a cell is tapped redirect to the Recipe view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recipes = filtered ? recipeList.filter { $0.isFavourite } : recipeList

        if recipes.count > indexPath.row{
            
            NavigationHelper.goToRecipeView(from: self, indexPath: indexPath, recipeList: recipeList, favourites: favourites)
            
        }
        
    }
    
}
