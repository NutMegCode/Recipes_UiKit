//
//  IngredientCell.swift
//  Paradigm Project
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setIngredient(ingredient: Ingredient){
        titleLabel.text = ingredient.name
    }


}

