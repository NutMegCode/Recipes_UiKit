//
//  IngredientCell.swift
//  Paradigm Project
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class IngredientCell: UITableViewCell {
    
    
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var uomLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setIngredient(qty: Float, uom: String, title: String){
        qtyLabel.text = "\(Int(qty))"
        uomLabel.text = uom
        titleLabel.text = title
    }


}

