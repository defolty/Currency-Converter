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
    /*
     стоит воспользоваться более лаконичной записью:
     
     DispatchQueue.main.async {
     ...
     }
     
     тут идет захват self'а, но утечек вроде бы не возникает
     в любом случае, стоит на всякий ослабить его через список захвата
     */
    DispatchQueue.main.async(execute: {
      self.present(alert, animated: true)
    })
  }
}
