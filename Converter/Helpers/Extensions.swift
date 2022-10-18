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
    Formatter.currentNumber.currencyGroupingSeparator = " "
    Formatter.currentNumber.currencyDecimalSeparator = "."
    Formatter.currentNumber.currencySymbol = ""
    return Formatter.currentNumber.string(for: self) ?? ""
  }
}

extension String {
  func currencyInputFormatting() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.decimalSeparator = "."
    formatter.groupingSeparator = " "
    formatter.maximumFractionDigits = 0
    formatter.minimumFractionDigits = 2
    
    var number: NSNumber!
    var amountWithPrefix = self
    
    let regex = try! NSRegularExpression(
      pattern: "[^0-9]",
      options: .caseInsensitive
    )
    amountWithPrefix = regex.stringByReplacingMatches(
      in: amountWithPrefix,
      options: NSRegularExpression.MatchingOptions(rawValue: 0),
      range: NSMakeRange(0, self.count),
      withTemplate: ""
    )
    
    let double = (amountWithPrefix as NSString).doubleValue
    number = NSNumber(value: (double / 100))
    
    guard number != 0 as NSNumber else {
      return ""
    }
    
    return formatter.string(from: number)!
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


