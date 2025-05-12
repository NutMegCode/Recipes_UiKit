//
//  IngredientCell.swift
//  Recipes
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class NewIngredientCell: UITableViewCell {
    // the New Ingredient cell, holds textfields for the ingredients QTY, UOM, and title allowing user input for each field
    // functionality to provide the data entered in the cells fileds if there is any
    
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var uomTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        qtyTextField.layer.borderColor = UIColor.lightGray.cgColor
        qtyTextField.layer.borderWidth = 0.5
        
        uomTextField.layer.borderColor = UIColor.lightGray.cgColor
        uomTextField.layer.borderWidth = 0.5
        
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.borderWidth = 0.5
        
    }

    func getIngredient() -> Ingredient? {

        let cleanedQty = qtyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedUom = uomTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let cleanedName = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let quantity = getStringToDouble(cleanedQty)

        // Return nil if all fields are blank or nil
        if quantity == nil, cleanedUom.isEmpty, cleanedName.isEmpty {
            return nil
        }

        let ingredient = Ingredient()
        ingredient.quantity = quantity
        ingredient.uom = cleanedUom
        ingredient.name = cleanedName

        return ingredient
    }
    
}

