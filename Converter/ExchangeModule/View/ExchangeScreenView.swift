//
//  MainScreenView.swift
//  Converter
//
//  Created by Nikita Nesporov on 05.10.2022.
//

import UIKit
import SnapKit

extension ExchangeScreenView: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    textField.validInput(textField: textField, range: range, string: string, numberOfCharacter: 8, maxDecimalPlaces: 2)
  }
}

extension ExchangeScreenView: ExchangeViewProtocol { 
  func updateViews(field: ActiveTextField) {
    firstCurrencySelectionButton.setTitle(
      presenter.fromCurrency,
      for: .normal)
    secondCurrencySelectionButton.setTitle(
      presenter.toCurrency,
      for: .normal)
    
    switch field {
    case .firstTextField:
      secondCurrencyTextField.text = presenter.valueForSecondField
    case .secondTextField:
      firstCurrencyTextField.text = presenter.valueForFirstField
    }
  }
  
  func showIndicator(show: Bool) {
    switch show {
    case true:
      activityIndicator.show()
    case false:
      activityIndicator.hide()
    }
  }
  
  func failure(error: Error) {
    self.showAlert(withTitle: "Error", withMessage: error.localizedDescription)
  }
}

final class ExchangeScreenView: UIViewController {
  
  let activityIndicator = ActivityIndicator()
  var presenter: ExchangeViewPresenterProtocol!
  var onButtonAction: (() -> Void)?
  private var scrollOffset : CGFloat = 0
  private var distance : CGFloat = 0
  
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
      scale: .default)
    let image = UIImage(
      systemName: "chevron.up.chevron.down",
      withConfiguration: config)
    swapButton.setImage(image, for: .normal)
    swapButton.tintColor = .systemIndigo
    swapButton.addTarget(
      self,
      action: #selector(selectCurrency),
      for: .touchUpInside)
    self.view.addSubview(swapButton)
    return swapButton
  }()
  
  private lazy var firstCurrencyTextField: UITextField = {
    let textfield = UITextField()
    textfield.placeholder = "You can type here..."
    textfield.text = "100"
    textfield.adjustsFontSizeToFitWidth = true
    textfield.textAlignment = .center
    textfield.textColor = .white
    textfield.backgroundColor = .systemPink
    textfield.keyboardType = .decimalPad
    textfield.layer.cornerRadius = 12
    textfield.isUserInteractionEnabled = true
    textfield.clearButtonMode = .always
    textfield.clearsOnBeginEditing = true
    textfield.smartDashesType = .no
    textfield.delegate = self
    textfield.addTarget(self, action: #selector(textFieldsDidEditing(textField:)), for: .editingDidEnd)
    self.view.addSubview(textfield)
    return textfield
  }()
  
  private lazy var secondCurrencyTextField: UITextField = {
    let textfield = UITextField()
    textfield.placeholder = "or here..."
    textfield.adjustsFontSizeToFitWidth = true
    textfield.textAlignment = .center
    textfield.textColor = .white
    textfield.backgroundColor = .systemPink
    textfield.keyboardType = .decimalPad
    textfield.layer.cornerRadius = 12
    textfield.isUserInteractionEnabled = true
    textfield.clearButtonMode = .always
    textfield.clearsOnBeginEditing = true
    textfield.smartDashesType = .no
    textfield.delegate = self
    textfield.addTarget(self, action: #selector(textFieldsDidEditing(textField:)), for: .editingDidEnd)
    self.view.addSubview(textfield)
    return textfield
  }()
  
  private lazy var firstCurrencySelectionButton: UIButton = {
    let button = UIButton(type: .system)
    button.tag = 1
    button.setTitle("EUR", for: .normal)
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
    button.setTitle("RUB", for: .normal)
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
    
    view.backgroundColor = .systemBackground
    addSubviews()
    setupNavigationBar()
    setupConstaints()
    registerForKeyboardNotifications()
    hideKeyboardWhenTappedAround()
    initialValues()
    presenter.tapOnButton()
  }
  
  // MARK: - Action's
  
  @objc
  private func selectCurrency(sender: UIButton) {
    //let selectedButton: SelectedButtonCondition = sender.tag == 1 ? .fromButton : .toButton
    guard let presenter else { return }
    onButtonAction?()
    presenter.tapOnButton()
  }
  
  @objc
  private func textFieldsDidEditing(textField: UITextField) {
    guard let text = textField.text else { return }
    let activeField: ActiveTextField = textField == firstCurrencyTextField ? .firstTextField : .secondTextField
    
    presenter.getValuesFromView(field: activeField, value: text)
    
    let textToDouble = Double(text)
    guard let textToDouble else { return } 
    
    textField.text = presenter.showNumbersToUser(numbers: textToDouble)
  }
  
  @objc
  private func settingsNavigationBarTapped() {
    print("settingsNavigationBarTapped")
  }
  
  // MARK: - Setup Views
  
  private func addSubviews() {
    view.addSubview(scrollView)
    view.addSubview(activityIndicator)
    activityIndicator.hide()
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
  
  private func initialValues() {
    presenter.fromCurrency = "EUR"
    presenter.toCurrency = "RUB"
    presenter.amount = "100"
    presenter.selectedButton = .fromButton
    presenter.getValuesFromView(field: .firstTextField, value: "100")
  }
  
  // MARK: - Setup Constraint's
  
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
      make.leading.equalTo(view).offset(50)
      make.bottom.equalTo(swapValue.snp.top).offset(-5)
    }
    
    firstCurrencyTextField.snp.makeConstraints { make in
      make.left.equalTo(firstCurrencySelectionButton.snp.right).offset(10)
      make.trailing.equalTo(view).offset(-50)
      make.height.equalTo(firstCurrencySelectionButton)
      make.centerY.equalTo(firstCurrencySelectionButton)
    }
    
    swapValue.snp.makeConstraints { make in
      make.width.equalTo(40)
      make.height.equalTo(40)
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
}

// MARK: - Keyboard Observer

extension ExchangeScreenView {
  
  private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  private func removeKeyboardNotifications() {
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      var safeArea = self.view.frame
      safeArea.size.height += scrollView.contentOffset.y
      safeArea.size.height -= keyboardSize.height + (UIScreen.main.bounds.height*0.04)
      let activeField: UIView? = [
        firstCurrencyTextField,
        secondCurrencyTextField
      ].first { $0.isFirstResponder }
      if let activeField = activeField {
        if safeArea.contains(CGPoint(
          x: 0,
          y: activeField.frame.maxY)) {
          return
        } else {
          distance = activeField.frame.maxY - safeArea.size.height
          scrollOffset = scrollView.contentOffset.y
          self.scrollView.setContentOffset(
            CGPoint(x: 0,y: scrollOffset + distance),
            animated: true
          )
        }
      }
      scrollView.isScrollEnabled = false
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if distance == 0 {
      return
    }
    self.scrollView.setContentOffset(
      CGPoint(x: 0, y: -scrollOffset - distance),
      animated: true
    )
    scrollOffset = 0
    distance = 0
    scrollView.isScrollEnabled = true
  }
  
  private func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissKeyboard)
    )
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc private func dismissKeyboard() {
    view.endEditing(true)
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

