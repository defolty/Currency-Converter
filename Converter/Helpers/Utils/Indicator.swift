//
//  Indicator.swift
//  Converter
//
//  Created by Nikita Nesporov on 21.12.2021.
//

import UIKit
/*
 не забываем про final
 */
class ActivityIndicator: UIVisualEffectView {
  /*
   эти все свойства делаем приватными
   */
  let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
  let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
  let vibrancyView: UIVisualEffectView
  
  init() {
    self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
    super.init(effect: blurEffect)
    /*
     self избыточен, убираем
     */
    self.setup()
  }
  /*
   этот обязательный инициализатор используется для других целей
   нужно использовать его дефолтную реализацию:
   
   required init?(coder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
   }
   */
  required init?(coder aDecoder: NSCoder) {
    self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
    super.init(coder: aDecoder)
    self.setup()
  }
  /*
   добавить приватность
   и перенести в самый низ
   */
  func setup() {
    contentView.addSubview(vibrancyView)
    vibrancyView.contentView.addSubview(activityIndictor)
    activityIndictor.hidesWhenStopped = true
    activityIndictor.startAnimating()
  }
  /*
   перенести выше, сразу после инита
   */
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    /*
     self избыточен, убираем
     
     весь код тут вынести в отдельный приватный метод
     */
    if let superview = self.superview {
      let width: CGFloat = 45.0
      let height: CGFloat = 45.0
      self.frame = CGRect(
        x: superview.frame.size.width / 2 - width / 2,
        y: superview.frame.height / 2 - height / 2,
        width: width,
        height: height
      )
      /*
       self избыточен, убираем
       */
      vibrancyView.frame = self.bounds
      
      let activityIndicatorSize: CGFloat = 40
      activityIndictor.frame = CGRect(
        x: width / 2 - activityIndicatorSize / 2,
        y: height / 2 - activityIndicatorSize / 2,
        width: activityIndicatorSize,
        height: activityIndicatorSize
      )
      layer.cornerRadius = 8.0
      layer.masksToBounds = true
    }
  }
  /*
   self избыточен, убираем
   */
  func show() {
    self.isHidden = false
  }
  /*
   self избыточен, убираем
   */
  func hide() {
    self.isHidden = true
  } 
}
