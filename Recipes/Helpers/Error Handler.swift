//
//  Error Handler.swift
//  Recipes
//
//  Created by Meg on 7/4/2025.
//
import UIKit

class ErrorHandler {
    // a class for the global error alert system
    static let shared = ErrorHandler()
    
    private init() {}

    weak var presentingViewController: UIViewController?

    // a function to show the error as an alert on the VC passed in
    func showError(title: String = "Error", message: String) {
        guard let vc = presentingViewController else {
            print("⚠️ No presenting VC set for ErrorHandler")
            return
        }

        // adding the displaying of the alert to the thread que - I beleive this is similar to Objective-C's Grand Central Dispatch
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            vc.present(alert, animated: true)
        }
    }
}
