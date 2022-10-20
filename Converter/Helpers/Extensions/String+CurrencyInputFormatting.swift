//
//  String+CurrencyInputFormatting.swift
//  Converter
//
//  Created by Nikita Nesporov on 20.10.2022.
//

import Foundation

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

