//
//  FloatingPoint+NumberFormatter.swift
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




