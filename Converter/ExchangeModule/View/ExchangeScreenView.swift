//
//  MainScreenView.swift
//  Converter
//
//  Created by Nikita Nesporov on 05.10.2022.
//

import UIKit
import SnapKit

extension ExchangeScreenView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let field: ActiveTextField = textField == firstCurrencyTextField ? .firstTextField : .secondTextField
//        presenter.getValuesFromView(activeField: field, value: textField.text ?? "ERR")
    }
}

extension ExchangeScreenView: ExchangeViewProtocol {
    
    func updateViews(field: ActiveTextField) {
        print("5")
        firstCurrencySelectionButton.setTitle(
            presenter.firstSelectedCurrency,
            for: .normal)
        secondCurrencySelectionButton.setTitle(
            presenter.secondSelectedCurrency,
            for: .normal)
          
        switch field {
        case .firstTextField:
            print("updateViews case .firstTextField")
            secondCurrencyTextField.text = presenter.valueForSecondField
        case .secondTextField:
            print("updateViews case .secondTextField")
            firstCurrencyTextField.text = presenter.valueForFirstField
        }
    }
    
    func failure(error: Error) {
        print("error ExchangeScreenView func failure", error.localizedDescription)
    }
}
 
class ExchangeScreenView: UIViewController {
     
    var presenter: ExchangeViewPresenterProtocol!
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.layer.cornerRadius = 12
        return contentView
    }()
      
    private lazy var swapValue: UIButton = {
        let swapButton = UIButton()
        let config = UIImage.SymbolConfiguration(
            pointSize: 100,
            weight: .regular,
            scale: .default
        )
        let image = UIImage(
            systemName: "arrow.up.arrow.down.square",
            withConfiguration: config
        )
        swapButton.setImage(image, for: .normal)
        swapButton.tintColor = .systemIndigo
        swapButton.addTarget(
            self,
            action: #selector(selectCurrency),
            for: .touchUpInside
        )
        self.view.addSubview(swapButton)
        return swapButton
    }()
    
    private lazy var firstCurrencyTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "0.0"
        textfield.textAlignment = .center
        textfield.textColor = .white
        textfield.backgroundColor = .systemPink
        textfield.keyboardType = .decimalPad
        textfield.layer.cornerRadius = 12
        textfield.isUserInteractionEnabled = true
        textfield.clearButtonMode = .whileEditing
        textfield.clearsOnBeginEditing = true
        textfield.delegate = self
        textfield.addTarget(self, action: #selector(textFieldsDidEditing(textField:)), for: .editingChanged)
        self.view.addSubview(textfield)
        return textfield
    }()
    
    private lazy var secondCurrencyTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "0.0"
        textfield.textAlignment = .center
        textfield.textColor = .white
        textfield.backgroundColor = .systemPink
        textfield.keyboardType = .decimalPad
        textfield.layer.cornerRadius = 12
        textfield.isUserInteractionEnabled = true
        textfield.clearButtonMode = .whileEditing
        textfield.clearsOnBeginEditing = true
        textfield.delegate = self
        textfield.addTarget(self, action: #selector(textFieldsDidEditing(textField:)), for: .editingChanged)
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
        initialValues()
    }
    
    @objc private func selectCurrency(sender: UIButton) {
//        let selectedButton: SelectedButtonCondition = sender.tag == 1 ? .fromButton : .toButton
        if let presenter {
            presenter.tapOnButton()
        } else {
            print("error router presenter.tapOnButton()")
        }
    }
    
    @objc private func textFieldsDidEditing(textField: UITextField) {
        print("6")
        guard let text = textField.text else { return }
        let activeField: ActiveTextField = textField == firstCurrencyTextField ? .firstTextField : .secondTextField
        
        presenter.getValuesFromView(field: activeField, value: text)
    }
     
    // MARK: - Setup Views
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView) 
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
            make.bottom.equalTo(swapValue.snp.top).offset(-5)
        }

        firstCurrencyTextField.snp.makeConstraints { make in
            make.left.equalTo(firstCurrencySelectionButton.snp.right).offset(10)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(firstCurrencySelectionButton)
            make.centerY.equalTo(firstCurrencySelectionButton)
        }
        
        swapValue.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(firstCurrencySelectionButton)
            make.centerY.equalTo(view)
        }
        
        secondCurrencySelectionButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.centerX.equalTo(firstCurrencySelectionButton)
            make.top.equalTo(swapValue.snp.bottom).offset(5)
        }

        secondCurrencyTextField.snp.makeConstraints { make in
            make.centerX.equalTo(firstCurrencyTextField)
            make.centerY.equalTo(secondCurrencySelectionButton)
            make.height.equalTo(secondCurrencySelectionButton)
            make.width.equalTo(firstCurrencyTextField)
        }
    }
    
    private func initialValues() {
        print("1")
        presenter.firstSelectedCurrency = "EUR"
        presenter.secondSelectedCurrency = "USD"
        presenter.amount = "100"
        presenter.selectedButton = .fromButton
        firstCurrencyTextField.text = presenter.amount
        presenter.getValuesFromView(field: .firstTextField, value: "100")
    }
}

//#if DEBUG
//import SwiftUI
//
//struct HomeViewController_Preview: PreviewProvider {
//    static var previews: some View = Preview(
//        for: ExchangeScreenView()
//    )
//}
//#endif
 
