//
//  Untitled.swift
//  Paradigm Project
//
//  Created by Meg on 17/3/2025.
//

class Recipe {
    var name: String? = nil
    var serves: Double? = nil
    var description: String? = nil
    var ingredients: [Ingredient?] = []
    var method: String? = nil
    var isFavourite: Bool = false
    
    init() {
    }
}

class Ingredient {
    var name: String? = nil
    var quantity: Double? = nil
    var uom: String? = nil
    var quantityPerOneServe: Double? = nil
    
    func getQuantityOfOneForServes(_ serves: Double?) -> Double {
        return (quantity ?? 0) / (serves ?? 0) //clarifying brackets are enforced here
    }
    
    init() {
    }
}

class Favourites {
    var favoiurites: [Recipe] = []
    
    // A closure to notify when a recipe is favorited (leaks memory!)
    var onFavouriteUpdate: (() -> Void)?

    func addToFavourites(_ recipe: Recipe) {
        recipe.isFavourite = true
        favoiurites.append(recipe)
        
        // Retain Cycle: Closure strongly captures `self`
        onFavouriteUpdate = {
            print("\(recipe.name ?? "Untitled") was added to favorites!")
            print("Total favorites: \(self.favoiurites.count)") // Strong reference to `self`
        }
    }
    
    func removeFromFavourites(_ recipe: Recipe) {
        recipe.isFavourite = false
        favoiurites.removeAll(where: {$0.name == recipe.name}) //okay we realy need some unique identifiers here...
        
        // Retain Cycle: Closure strongly captures `self`
        onFavouriteUpdate = {
            print("\(recipe.name ?? "Untitled") was removed from favorites!")
            print("Total favorites: \(self.favoiurites.count)") // Strong reference to `self`
        }
    }
    
    init() {
    }
}
