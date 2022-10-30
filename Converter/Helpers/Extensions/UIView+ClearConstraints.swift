//
//  UIView+ClearConstraints.swift
//  Converter
//
//  Created by Nikita Nesporov on 29.10.2022.
//

import UIKit

extension UIView {
  func clearConstraints() {
    for subview in self.subviews {
      subview.clearConstraints()
    }
    self.removeConstraints(self.constraints)
  }
}
 
