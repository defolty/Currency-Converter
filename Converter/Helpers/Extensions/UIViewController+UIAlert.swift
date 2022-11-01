//
//  UIViewController+UIAlert.swift
//  Converter
//
//  Created by Nikita Nesporov on 20.10.2022.
//

import UIKit

extension UIViewController {
  func showAlert(withTitle title: String, withMessage message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: { action in })
    alert.addAction(ok)
     
    DispatchQueue.main.async {
      self.present(alert, animated: true)
    }
  }
}
