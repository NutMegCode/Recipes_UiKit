//
//  Utils.swift
//  Recipes
//
//  Created by Meg on 20/3/2025.
//

import Foundation
import UIKit

// a function to convert an optional Double? type to a String.
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

// a function to convert an optional String? type to a Double. If it is unable to perform the conversion an error is thrown and the global alert system is triggered showing an alert to the user informing them of the error
func getStringToDouble(_ myStr: String?) -> Double? {
    
    guard let myStr = myStr?.trimmingCharacters(in: .whitespacesAndNewlines), !myStr.isEmpty else {
        return nil
    }
    
    var myNum: Double?
    
    //some error handling! this could aslo be handled through simple if then logic
    do {
        if let num = Double(myStr) {
            myNum = num
        } else {
            throw NSError(domain: "ConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not convert \(myStr) to a number"])
        }
    } catch {
        // an error is thrown! catch it no matter what type of error it is, and trigger the global aret system to display the error to the user
        ErrorHandler.shared.showError(message: error.localizedDescription)
        myNum = nil
    }
    
    return myNum
}

// extends the functionality of the base libraries UIViewController class to include the ability to display an alert when an error occurs
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

// a protocol to drive control of the global error alert system
protocol CellErrorDisplayDelegate: AnyObject {
    func showError(message: String, title: String)
}
