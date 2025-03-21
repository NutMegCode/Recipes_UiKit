//
//  IngredientCell.swift
//  Paradigm Project
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class NewIngredientCell: UITableViewCell {
    
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var uomTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getIngredient() -> Ingredient{
        var ingredient:Ingredient = Ingredient()
        ingredient.quantity = Double(qtyTextField.text ?? "0") ?? 0
        ingredient.uom = uomTextField.text ?? ""
        ingredient.name = titleTextField.text ?? ""
        return ingredient
    }
    
}

