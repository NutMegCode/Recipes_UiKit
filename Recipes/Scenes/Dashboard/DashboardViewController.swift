//
//  DashboardViewController.swift
//  Recipes
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var recipeTable: UITableView!
    @IBOutlet weak var filterFavouritesImage: UIImageView!
    @IBOutlet weak var EmptyLabel: UILabel!
    
    var recipeList: [Recipe] = []
    
    var favourites: Favourites? = nil
    
    var filtered = false
    
    let importer = RecipeImporter()
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        favourites = FavouritesStorage().loadFavourites()
        
        recipeList = RecipeStorage().loadRecipes()
        
        handleEmptyView()
        
        recipeTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        
        handleEmptyView()
        
        filterFavouritesImage.image = filtered ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
    }
    
    private func handleEmptyView() {
        EmptyLabel.isHidden = (filtered ? recipeList.filter { $0.isFavourite }.count : recipeList.count) != 0 //its one line sure, but is it easy to read? ... no
        EmptyLabel.text = filtered ? "No favourite recipes" : "No recipes"
    }
    
    let recipeCellIdentifier = "RecipeCell"

    private func setupTable() {
        
        let recipeCellNib = UINib(nibName: recipeCellIdentifier, bundle: nil)
        recipeTable.register(recipeCellNib, forCellReuseIdentifier: recipeCellIdentifier)
        
    }
    
    
    @IBAction func addNewPressed(_ sender: Any) {
        
        NavigationHelper.goToNewRecipeView(from: self, recipeList: recipeList, favourites: favourites)
        
    }
    
    
    @IBAction func filterFavouritePressed(_ sender: Any) {
        
        filtered.toggle()
        recipeTable.reloadData()
        
        filterFavouritesImage.image = filtered ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        handleEmptyView()

    }
    
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
            
            NavigationHelper.goToRecipeView(from: self, indexPath: indexPath, recipeList: recipeList, favourites: favourites)
            
        }
        
    }
    
}
