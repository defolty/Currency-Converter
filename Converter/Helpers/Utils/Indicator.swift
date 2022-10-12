//
//  Indicator.swift
//  Converter
//
//  Created by Nikita Nesporov on 21.12.2021.
//

import UIKit

class ActivityIndicator: UIVisualEffectView {
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    let blurEffect = UIBlurEffect(style: .dark)
    let vibrancyView: UIVisualEffectView
    
    init() {
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        vibrancyView.contentView.addSubview(activityIndictor)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            let width: CGFloat = 45.0
            let height: CGFloat = 45.0
            self.frame = CGRect(
                x: superview.frame.size.width / 2 - width / 2,
                y: superview.frame.height / 2 - height / 2,
                width: width,
                height: height
            )
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
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    } 
}
