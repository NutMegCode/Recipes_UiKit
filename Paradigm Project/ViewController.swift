//
//  ViewController.swift
//  Paradigm Project
//
//  Created by Meg on 28/2/2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var methodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Spag Bol"
        descriptionLabel.text = "A classic Italian dish"
        methodLabel.text = "1. Boil water. \n2. Add pasta. \n3. Add sauce. \n4. Cook pasta."
        
        // Do any additional setup after loading the view.
    }
}

