//
//  Extensions.swift
//  Converter
//
//  Created by Nikita Nesporov on 20.01.2022.
//

//import UIKit
//
//extension String {
//    
//    func maxDecimalPlaces(_ maxDecimalPlaces: Int) -> Bool {
//        let formatter = NumberFormatter()
//        formatter.allowsFloats = true
//        let decimalSeparator = formatter.decimalSeparator ?? "."
//        if formatter.number(from: self) != nil {
//            let split = self.components(separatedBy: decimalSeparator)
//            let digits = split.count == 2 ? split.last ?? "" : ""
//            return digits.count <= maxDecimalPlaces
//        }
//        return false
//    }
//}
//
//extension UITextField {
//    
//    @objc private func dismissKeyboard() {
//        resignFirstResponder()
//    }
//    
//    @objc private func invertValue() {
//        if let value = Double(text!) {
//            return text = String(format: "%g",value * -1)
//        } else {
//            return text = ""
//        }
//    }
//    
//    func validInput(textField: UITextField, range: NSRange, string: String, numberOfCharacter: Int, maxDecimalPlaces: Int) -> Bool {
//        
//        if string.isEmpty { return true }
//        
//        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
//            return true
//        }
//        
//        let newText = oldText.replacingCharacters(in: r, with: string) 
//        let substringToReplace = oldText[r]
//        let numberOfCharacters = oldText.count - substringToReplace.count + string.count
//        
//        return numberOfCharacters <= numberOfCharacter && newText.maxDecimalPlaces(maxDecimalPlaces)
//    }
//}
//
//extension UIViewController {
//    
//    func removeKeyboardObserver() {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
//    
//    func showAlert(withTitle title: String, withMessage message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in })
//        alert.addAction(ok)
//        
//        DispatchQueue.main.async(execute: {
//            self.present(alert, animated: true)
//        })
//    }
//}
