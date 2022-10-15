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
    Formatter.currentNumber.numberStyle = .decimal
    return Formatter.currentNumber.string(for: self) ?? ""
  }
}

extension String {
  func maxDecimalPlaces(_ maxDecimalPlaces: Int) -> Bool {
    let formatter = NumberFormatter()
    formatter.allowsFloats = true
    let decimalSeparator = formatter.decimalSeparator ?? "."
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
    let substringToReplace = oldText[range]
    let numberOfCharacters = oldText.count - substringToReplace.count + string.count
    
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


