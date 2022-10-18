//
//  Extensions.swift
//  Converter
//
//  Created by Nikita Nesporov on 20.01.2022.
//

import UIKit
  
extension Formatter {
  static let currentNumber = NumberFormatter()
}

extension FloatingPoint {
  func fractionDigits(min: Int = 0, max: Int = 2, roundingMode: NumberFormatter.RoundingMode = .halfEven) -> String {
    Formatter.currentNumber.minimumFractionDigits = min
    Formatter.currentNumber.maximumFractionDigits = max
    Formatter.currentNumber.roundingMode = roundingMode
    Formatter.currentNumber.numberStyle = .currency
    Formatter.currentNumber.usesGroupingSeparator = true
    Formatter.currentNumber.currencyGroupingSeparator = ","
    Formatter.currentNumber.currencyDecimalSeparator = "."
    Formatter.currentNumber.currencySymbol = ""
    return Formatter.currentNumber.string(for: self) ?? ""
  }
}
 
extension String {
  
  // formatting text for currency textField
  func currencyInputFormatting() -> String {
    
    var number: NSNumber!
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal //.currencyAccounting
//    formatter.currencySymbol = ""
//    formatter.currencyGroupingSeparator = ","
//    formatter.currencyDecimalSeparator = "."
    formatter.decimalSeparator = "."
    formatter.groupingSeparator = ","
    formatter.maximumFractionDigits = 0
    formatter.minimumFractionDigits = 2
    
    var amountWithPrefix = self
    
    // remove from String: "$", ".", ","
    let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    amountWithPrefix = regex.stringByReplacingMatches(
      in: amountWithPrefix,
      options: NSRegularExpression.MatchingOptions(rawValue: 0),
      range: NSMakeRange(0, self.count),
      withTemplate: ""
    )
    let double = (amountWithPrefix as NSString).doubleValue
    number = NSNumber(value: (double / 100))
    
    // if first number is 0 or all numbers were deleted
    guard number != 0 as NSNumber else {
      return ""
    }
    
    return formatter.string(from: number)!
  }
}

extension String {
  func maxDecimalPlaces(_ maxDecimalPlaces: Int) -> Bool {
    let formatter = NumberFormatter()
    formatter.allowsFloats = true
    let decimalSeparator = formatter.decimalSeparator ?? "," ///# `.`
    if formatter.number(from: self) != nil {
      let split = self.components(separatedBy: decimalSeparator)
      let digits = split.count == 2 ? split.last ?? "" : ""
      return digits.count <= maxDecimalPlaces
    }
    return false
  }
}

extension UITextField {
  func validInput(textField: UITextField, range: NSRange, string: String, numberOfCharacter: Int, maxDecimalPlaces: Int) -> Bool {
    if string.isEmpty { return true }
    guard let oldText = textField.text, let range = Range(range, in: oldText) else { return true }
      
    let newText = oldText.replacingCharacters(in: range, with: string)
    let stringToReplace = oldText[range]
    let numberOfCharacters = oldText.count - stringToReplace.count + string.count
     
    return numberOfCharacters <= numberOfCharacter && newText.maxDecimalPlaces(maxDecimalPlaces)
  }
}

extension UIViewController {
  func showAlert(withTitle title: String, withMessage message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: { action in })
    alert.addAction(ok)
    
    DispatchQueue.main.async(execute: {
      self.present(alert, animated: true)
    })
  }
}


