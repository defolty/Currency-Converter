//
//  Indicator.swift
//  Converter
//
//  Created by Nikita Nesporov on 21.12.2021.
//

import UIKit

final class ActivityIndicator: UIVisualEffectView {
   
  private let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
  private let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
  private let vibrancyView: UIVisualEffectView
  
  init() {
    self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
    super.init(effect: blurEffect)
     
    setup()
  }
   
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
   
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    configureIndicator()
  }
  
  private func configureIndicator() {
    if let superview = superview {
      let width: CGFloat = 30.0
      let height: CGFloat = 30.0
      frame = CGRect(
        x: superview.frame.size.width / 2 - width / 2,
        y: superview.frame.height / 2 - height / 2,
        width: width,
        height: height
      )
      
      vibrancyView.frame = bounds
      
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
  
  private func setup() {
    contentView.addSubview(vibrancyView)
    vibrancyView.contentView.addSubview(activityIndictor)
    activityIndictor.hidesWhenStopped = true
    activityIndictor.startAnimating()
  }
  
  func show() {
    isHidden = false
  }
  
  func hide() {
    isHidden = true
  }
}
