//
//  MainScreenView.swift
//  Converter
//
//  Created by Nikita Nesporov on 05.10.2022.
//

import UIKit
import SnapKit

enum CurrentSelectedButton {
    case firstButton, secondButton
}

enum CurrentActiveTextField {
    case firstTextField, secondTextField
}
 
class ExchangeScreenView: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //scrollView.backgroundColor = .lightGray
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        //contentView.backgroundColor = .systemGray2
        contentView.layer.cornerRadius = 12
        return contentView
    }()
     
    private let swapValues: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "Swap")
        imageView.image = UIImage(systemName: "arrow.up.arrow.down.square")
        imageView.layer.cornerRadius = 12
        imageView.sizeToFit()
        return imageView
    }()
    
    private lazy var firstCurrencyTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "0.0"
        textfield.textAlignment = .center
        textfield.textColor = .white
        textfield.backgroundColor = .systemPink
        textfield.keyboardType = .numberPad
        textfield.layer.cornerRadius = 12
        textfield.isUserInteractionEnabled = true
        textfield.addTarget(textfield, action: #selector(firstTextField), for: .touchUpInside)
        self.view.addSubview(textfield)
        return textfield
    }()
    
    private lazy var secondCurrencyTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "0.0"
        textfield.textAlignment = .center
        textfield.textColor = .white
        textfield.backgroundColor = .systemPink
        textfield.keyboardType = .numberPad
        textfield.layer.cornerRadius = 12
        textfield.isUserInteractionEnabled = true
        self.view.addSubview(textfield)
        return textfield
    }()
    
    private lazy var firstCurrencySelectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 1
        button.setTitle("First", for: .normal)
        button.backgroundColor = .systemIndigo
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(selectCurrency), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        self.view.addSubview(button)
        return button
    }()
    
    private lazy var secondCurrencySelectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 2
        button.setTitle("Second", for: .normal)
        button.backgroundColor = .systemIndigo
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(selectCurrency), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        self.view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupNavigationBar()
        setupConstaints()
    }
    
    @objc private func selectCurrency(sender: UIButton) {
        //let selectedButton: CurrentSelectedButton = sender.tag == 1 ? .firstButton : .secondButton
        //navigationController?.pushViewController(selectedVC, animated: true)
        print("tapped")
    }
    
    @objc private func firstTextField(sender: UITextField) {
        print("tapped")
    }
    
    // MARK: - Setup Views
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(swapValues)
        //contentView.addSubview(firstCurrencySelectionButton)
        //contentView.addSubview(firstCurrencyTextField)
        //contentView.addSubview(secondCurrencySelectionButton)
        //contentView.addSubview(secondCurrencyTextField)
    }
    
    private func setupNavigationBar() {
        title = "Currency Converter"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsNavigationBarTapped)
        )
    }
    
    @objc private func settingsNavigationBarTapped() {
        print("settingsNavigationBarTapped")
    }
     
    private func setupConstaints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.top.bottom.equalToSuperview()
        }
         
        firstCurrencySelectionButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.leading.equalTo(view).offset(30)
            make.bottom.equalTo(swapValues.snp.top).offset(-5)
        }

        firstCurrencyTextField.snp.makeConstraints { make in
            make.left.equalTo(firstCurrencySelectionButton.snp.right).offset(10)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(firstCurrencySelectionButton)
            make.centerY.equalTo(firstCurrencySelectionButton)
        }
        
        swapValues.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(firstCurrencySelectionButton)
            make.centerY.equalTo(view)
        }
        
        secondCurrencySelectionButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.centerX.equalTo(firstCurrencySelectionButton)
            make.top.equalTo(swapValues.snp.bottom).offset(5)
        }

        secondCurrencyTextField.snp.makeConstraints { make in
            make.centerX.equalTo(firstCurrencyTextField)
            make.centerY.equalTo(secondCurrencySelectionButton)
            make.height.equalTo(secondCurrencySelectionButton)
            make.width.equalTo(firstCurrencyTextField)
        }
    }
}

#if DEBUG
import SwiftUI

struct HomeViewController_Preview: PreviewProvider {
    static var previews: some View = Preview(
        for: ExchangeScreenView()
    )
}
#endif
 
