//
//  UIResponder.swift
//  Converter
//
//  Created by Nikita Nesporov on 26.10.2022.
//

import UIKit

extension UIResponder {
  
  static weak var responder: UIResponder?
  
  static func currentFirst() -> UIResponder? {
    responder = nil
    UIApplication.shared.sendAction(#selector(trap), to: nil, from: nil, for: nil)
    return responder
  }
  
  @objc private func trap() {
    UIResponder.responder = self
  }
}