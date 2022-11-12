//
//  UIViewController+KeyboardObserver.swift
//  Converter
//
//  Created by Nikita Nesporov on 26.10.2022.
//
  
import UIKit

extension UIViewController {
  
  func addKeyboardObserver() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(keyboardNotifications(notification:)),
      name: UIResponder.keyboardWillChangeFrameNotification,
      object: nil
    )
  }
  
  func removeKeyboardObserver(){
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillChangeFrameNotification, object: nil
    )
  }
   
  @objc
  func keyboardNotifications(notification: NSNotification) {
    
    var txtFieldY : CGFloat = 0.0
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let spaceBetweenTxtFieldAndKeyboard : CGFloat = 10.0
    
    if let activeTextField = UIResponder.currentFirst() as? UITextField ?? UIResponder.currentFirst() as? UITextView {
      frame = self.view.convert(activeTextField.frame, from:activeTextField.superview)
      txtFieldY = frame.origin.y + frame.size.height
    }
    
    if let userInfo = notification.userInfo {
      let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      let keyBoardFrameY = keyBoardFrame!.origin.y
      let keyBoardFrameHeight = keyBoardFrame!.size.height
      
      var viewOriginY: CGFloat = 0.0
      
      if keyBoardFrameY >= UIScreen.main.bounds.size.height {
        viewOriginY = 0.0
      } else {
        if txtFieldY >= keyBoardFrameY {
          
          viewOriginY = (txtFieldY - keyBoardFrameY) + spaceBetweenTxtFieldAndKeyboard
          
          if viewOriginY > keyBoardFrameHeight { viewOriginY = keyBoardFrameHeight }
        }
      }
       
      self.view.frame.origin.y = -viewOriginY
    }
  }
}
