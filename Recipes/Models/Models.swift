//
//  Untitled.swift
//  Recipes
//
//  Created by Meg on 17/3/2025.
//

import Foundation

// The Recipe class
class Recipe: Codable {
    var name: String?
    var serves: Double?
    var description: String?
    var ingredients: [Ingredient?]
    var method: String?
    var isFavourite: Bool

    // initialisation
    init(name: String? = nil, serves: Double? = nil, description: String? = nil, ingredients: [Ingredient] = [], method: String? = nil, isFavourite: Bool = false) {
        self.name = name
        self.serves = serves
        self.description = description
        self.ingredients = ingredients
        self.method = method
        self.isFavourite = isFavourite
    }
    
    // a function to determine if the entire class actually has no data
    func isEmpty() -> Bool {
        
        return name?.isEmpty ?? true && serves == nil && description?.isEmpty ?? true && ingredients.isEmpty && method?.isEmpty ?? true
    }
}

// the ingredient class, many of these belong to one of the Recipes
class Ingredient: Codable {
    var name: String?
    var quantity: Double?
    var uom: String?
    var quantityPerOneServe: Decimal?

    // initialisation
    init(name: String? = nil, quantity: Double? = nil, uom: String? = nil, quantityPerOneServe: Decimal? = nil) {
        self.name = name
        self.quantity = quantity
        self.uom = uom
        self.quantityPerOneServe = quantityPerOneServe
    }
    
    // a function used as part of the quantity recalculation. if we know how much wty per 1 serve we can easily calculate for other serves
    func getQuantityOfOneForServes(_ serves: Decimal?) -> Decimal {
        return Decimal((quantity ?? 0)) / (serves ?? 1) // Avoid division by zero
    }

    // this is A LOT of boilerplate that essentially is ONLY needed for the JSON exporting and importing of recipes
    enum CodingKeys: String, CodingKey {
        case name, quantity, uom, quantityPerOneServe
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        quantity = try container.decodeIfPresent(Double.self, forKey: .quantity)
        uom = try container.decodeIfPresent(String.self, forKey: .uom)
        if let decimalString = try container.decodeIfPresent(String.self, forKey: .quantityPerOneServe) {
            quantityPerOneServe = Decimal(string: decimalString)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(quantity, forKey: .quantity)
        try container.encodeIfPresent(uom, forKey: .uom)
        if let quantityPerOneServe = quantityPerOneServe {
            try container.encode("\(quantityPerOneServe)", forKey: .quantityPerOneServe) // Store Decimal as String
        }
    }
}

// The favourites class - this is an extrenuous class whose express purpose it is to demonstrate how a memory leak can be inadvertantly created and easily overlooked. this entire class could easily be replaced by a simple Boolean value on the Recipe class
class Favourites: Codable {
    var favourites: [Recipe] = []
    
    // A closure to notify when a recipe is favorited (leaks memory!)
    var onFavouriteUpdate: (() -> Void)?
    
    deinit {
        // when this is printed we can see object is deinitialised appropriately and is not hanging around causing memory leaks. if you open a Recipe and then immediately close it without toggling its favourite status, you will see this printed
        debugPrint("Favourites deinitialized")
    }

    // a function to add the recipe to the Recipies own Favourite recipes list
    func addToFavourites(_ recipe: Recipe) {
        recipe.isFavourite = true
        favourites.append(recipe)
        
        // Retain Cycle: Closure strongly captures `self`
        onFavouriteUpdate = {
            debugPrint("\(recipe.name ?? "Untitled") was added to favorites!")
            debugPrint("Total favorites: \(self.favourites.count)") // Strong reference to `self` if you comment out the this line and line 115 the deinit should happen
        }
        
        onFavouriteUpdate?()
    }
    
    func removeFromFavourites(_ recipe: Recipe) {
        recipe.isFavourite = false
        favourites.removeAll(where: {$0.name == recipe.name}) //okay we realy need some unique identifiers here... checking based on name is not ideal especially when there are no guard against repeated names
        
        // Retain Cycle: Closure strongly captures `self`
        onFavouriteUpdate = {
            debugPrint("\(recipe.name ?? "Untitled") was removed from favorites!")
            debugPrint("Total favorites: \(self.favourites.count)") // Strong reference to `self` if you comment out the this line and line 102 the deinit should happen
        }
        
        onFavouriteUpdate?()
    }
    

    // more boilerplate 
    init() {}

    // MARK: - Codable Conformance
    enum CodingKeys: String, CodingKey {
        case favourites
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        favourites = try container.decodeIfPresent([Recipe].self, forKey: .favourites) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(favourites, forKey: .favourites)
    }
}
