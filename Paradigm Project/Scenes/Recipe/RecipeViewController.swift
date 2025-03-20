//
//  ViewController.swift
//  Paradigm Project
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var servesField: UITextField!
    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var methodLabel: UILabel!
    
    @IBOutlet weak var favouriteImage: UIImageView!
    
    
    @IBOutlet weak var ingredientTableHeight: NSLayoutConstraint!
    
    var recipe: Recipe? = nil
    
    var isFavourite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = recipe?.name ?? "-"
        descriptionLabel.text = recipe?.description ?? "-"
        methodLabel.text = recipe?.method ?? "-"
        servesField.text = "\(recipe?.serves ?? 0)"
        
        isFavourite = recipe?.favourites?.favoiurites.contains(where: { $0.name == recipe?.name }) ?? false
        
        favouriteImage.image = isFavourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        setupTable()
        
        // Do any additional setup after loading the view.
    }
    
    let jobCellIdentifier = "IngredientCell"

    private func setupTable() {
        
        let jobCellNib = UINib(nibName: jobCellIdentifier, bundle: nil)
        ingredientsTable.register(jobCellNib, forCellReuseIdentifier: jobCellIdentifier)
        
        ingredientTableHeight.constant = 50
        
    }
    
    @IBAction func recalculateAsFloat(_ sender: Any) {
        
        if let ingredientsList = recipe?.ingredients,
           let serves = Double(servesField.text ?? "0"){
            
            for ingredient in ingredientsList {
                if let quantityPerOneServe = ingredient?.quantityPerOneServe {
                    ingredient?.quantity = quantityPerOneServe * serves
                }
            }
        }
        
        ingredientsTable.reloadData()
    }
    
    @IBAction func recalculateAsFDouble(_ sender: Any) {
        
        if let ingredientsList = recipe?.ingredients,
           let serves = Float(servesField.text ?? "0"){
            
            for ingredient in ingredientsList {
                if let quantityPerOneServe = ingredient?.quantityPerOneServe {
                    ingredient?.quantity = Double(Float(quantityPerOneServe) * serves)
                }

            }
            
                
        }
        
        ingredientsTable.reloadData()
    }
    
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        if let recipe = recipe {
            recipe.favourites?.favoiurites.append(recipe)
            
            isFavourite = recipe.favourites?.favoiurites.contains(where: { $0.name == recipe.name }) ?? false
            
            favouriteImage.image = isFavourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")

        }
        
    }
    
}

extension RecipeViewController: UITextFieldDelegate {
    
    
    
}

extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: jobCellIdentifier, for: indexPath) as? IngredientCell
        
        let ingredients = recipe?.ingredients
        
        if  let cell,
            let ingredients,
            ingredients.count > indexPath.row {
            
            if let ingredient = ingredients[indexPath.row]{
                
                cell.setIngredient(ingredient: ingredient)
            } else {
                debugPrint("Error: with the ingredient Cell")
                return UITableViewCell()
            }
                        
            return cell
            
        } else {
            debugPrint("Error: with the ingredient Cell")
            return UITableViewCell()
        }

        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let things = viewModel.output.things.value
//
//        if let things,
//           things.count > indexPath.row,
//           let thing = serviceJobs[indexPath.row].thing {
//
//            myCoordinator.start(thing: thing)
//
//        }
//
//    }
}

