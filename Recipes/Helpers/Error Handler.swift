//
//  Error Handler.swift
//  Recipes
//
//  Created by Meg on 7/4/2025.
//
import UIKit

class ErrorHandler {
    static let shared = ErrorHandler()
    
    private init() {}

    weak var presentingViewController: UIViewController?

    func showError(title: String = "Error", message: String) {
        guard let vc = presentingViewController else {
            print("⚠️ No presenting VC set for ErrorHandler")
            return
        }

        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            vc.present(alert, animated: true)
        }
    }
}
