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
    
    @IBOutlet weak var ingredientTableHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Spag Bol"
        descriptionLabel.text = "A classic Italian dish"
        methodLabel.text = "1. Boil water. \n2. Add pasta. \n3. Add sauce. \n4. Cook pasta."
        
        setupTable()
        
        // Do any additional setup after loading the view.
    }
    
    let jobCellIdentifier = "IngredientCell"

    private func setupTable() {
        
        let jobCellNib = UINib(nibName: jobCellIdentifier, bundle: nil)
        ingredientsTable.register(jobCellNib, forCellReuseIdentifier: jobCellIdentifier)
        
        ingredientTableHeight.constant = 50
        
    }
}

extension RecipeViewController: UITextFieldDelegate {
    
    
    
}

extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: jobCellIdentifier, for: indexPath) as? IngredientCell
        
        if  let cell{
            cell.setIngredient(qty: 500, uom: "grams", title: "Mince")
                        
            return cell
            
        } else {
            debugPrint("Error: with the job Cell")
            return UITableViewCell()
        }

        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let serviceJobs = viewModel.output.serviceJobs.value
//        
//        if let serviceJobs,
//           serviceJobs.count > indexPath.row,
//           let serviceJobID = serviceJobs[indexPath.row].serviceJobID {
//            
//            JobDetailCoordinator.start(serviceJobID: serviceJobID,
//                                       bookingID: nil,
//                                       dataRepo: viewModel.dataRepo)
//
//        }
//
//    }
}

