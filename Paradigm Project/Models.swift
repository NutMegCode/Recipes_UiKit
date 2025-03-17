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
    var favourites: Favourites? = nil //Hard circular reference which causes a memory leak here
    
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
    
    init() {
    }
}
