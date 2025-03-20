//
//  File Managers.swift
//  Paradigm Project
//
//  Created by Meg on 20/3/2025.
//

//we can manage local storage files without needing to import anything beyond Foundation!!
import Foundation


class FavouritesStorage {
    private let fileName = "MyRecipes_favorites.json"

    func saveFavorites(_ favorites: Favourites?) {
        
        if let favorites = favorites {
            
            let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
            do {
                let data = try JSONEncoder().encode(favorites)
                try data.write(to: fileURL)
            } catch {
                print("Error saving favorites: \(error)")
            }
        }
    }

    func loadFavourites() -> Favourites {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            let emptyFavorites = Favourites()
            saveFavorites(emptyFavorites) // Create an empty file
            return emptyFavorites
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(Favourites.self, from: data)
        } catch {
            print("Error loading favorites: \(error)")
            return Favourites()
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

class RecipeStorage {
    private let fileName = "MyRecipes_recipes.json"

    func saveRecipes(_ recipes: [Recipe]) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let data = try JSONEncoder().encode(recipes)
            try data.write(to: fileURL)
        } catch {
            print("Error saving recipes: \(error)")
        }
    }

    func loadRecipes() -> [Recipe] {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            let emptyRecipes: [Recipe] = []
            saveRecipes(emptyRecipes) // Create an empty file
            return emptyRecipes
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([Recipe].self, from: data)
        } catch {
            print("Error loading recipes: \(error)")
            return []
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
