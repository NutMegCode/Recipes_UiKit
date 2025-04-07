//
//  Utils.swift
//  Recipes
//
//  Created by Meg on 20/3/2025.
//

import Foundation
import UIKit

//Convert Double? to String
func getDoubleToString(_ myNum: Double?) -> String {
    
    guard let myNum = myNum else {
        return ""
    }
    
    var strNum = ""
    
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0  // Ensure no decimal places
    
    let decimalPart = myNum.truncatingRemainder(dividingBy: 1)
    
    if decimalPart == 0 {
        formatter.maximumFractionDigits = 0  // No decimals for whole numbers
    } else if decimalPart * 10 == floor(decimalPart * 10) {
        formatter.maximumFractionDigits = 1  // Show one decimal if it only has one
    } else {
        formatter.maximumFractionDigits = 2  // Otherwise, show two decimals
    }
    
    strNum = formatter.string(for: myNum) ?? ""
    
    return strNum
}


func getStringToDouble(_ myStr: String?) -> Double? {
    
    guard let myStr = myStr?.trimmingCharacters(in: .whitespacesAndNewlines), !myStr.isEmpty else {
        return nil
    }
    
    var myNum: Double?
    
    do {
        if let num = Double(myStr) {
            myNum = num
        } else {
            throw NSError(domain: "ConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not convert \(myStr) to a number"])
        }
    } catch {
        ErrorHandler.shared.showError(message: error.localizedDescription)
        myNum = nil
    }
    
    return myNum
}

extension UIViewController {
    func showErrorAlert(message: String, title: String = "Error") {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default))
        present(alertController, animated: true)
    }
}

protocol CellErrorDisplayDelegate: AnyObject {
    func showError(message: String, title: String)
}
