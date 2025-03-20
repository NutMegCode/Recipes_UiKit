//
//  IngredientCell.swift
//  Paradigm Project
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favouriteImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setRecipe(recipe: Recipe){
        
        titleLabel.text = recipe.name
        favouriteImage.image = recipe.isFavourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
}

