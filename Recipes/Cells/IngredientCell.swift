//
//  IngredientCell.swift
//  Recipes
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class IngredientCell: UITableViewCell {
// the Ingredient cell, just displays the ingredients data
    
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var uomLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setIngredient(ingredient: Ingredient){
        qtyLabel.text = getDoubleToString(ingredient.quantity)
        uomLabel.text = ingredient.uom
        titleLabel.text = ingredient.name
    }
    
}

