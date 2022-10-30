//
//  ExchangeViewController.swift
//  Converter
//
//  Created by Nikita Nesporov on 05.10.2022.
//

import UIKit
 
  // MARK: - View Protocol

protocol ExchangeViewProtocol: AnyObject {
  func presentIndicator(isShow: Bool)
  func presentUpdatedViews(_ field: ActiveTextField)
  func onFailure(error: Error)
  var onShowButtonAction: (() -> Void)? { get set }
}
 
  // MARK: - Class Exchange ViewController

final class ExchangeViewController: UIViewController {
  
  // MARK: - Properties
  
  var presenter: ExchangeViewPresenterProtocol!
  weak var baseCurrencyDelegate: AllExchangedViewDelegate?
  private let activityIndicator = ActivityIndicator()
  
  private var scrollOffset : CGFloat = 0
  private var distance : CGFloat = 0
  private var currencyDidSelected: String?
  
  var onShowButtonAction: (() -> Void)?
  var resetConstraintsIfNeeded: Bool = false {
    didSet {
      
      animateView(view: showAllExchangedCurrenciesList, hidden: false)
      
      setupConstaints(0.3)
    }
  }
  
  // MARK: - UI Elements
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentInsetAdjustmentBehavior = .never
    return scrollView
  }()
  
  private lazy var swapButtons = UIButton()
  
  private lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var middleView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    view.setContentHuggingPriority(.required, for: .vertical)
    return view
  }()
  
  private lazy var centralView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    return view
  }()
  
  private lazy var firstCurrencyTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = Constants.Titles.firstCurrencyTextFieldPlaceholder
    textField.text = Constants.InitialValues.firstCurrencyTextFieldInitialValue
    return textField
  }()
  
  private lazy var secondCurrencyTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = Constants.Titles.secondCurrencyTextFieldPlaceholder
    return textField
  }()
  
  private lazy var fromCurrencySelectionButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle(Constants.InitialValues.fromCurrencySelectionButtonInitialValue, for: .normal)
    return button
  }()
  
  private lazy var toCurrencySelectionButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle(Constants.InitialValues.toCurrencySelectionButtonInitialValue, for: .normal)
    return button
  }()
  
  private lazy var showAllExchangedCurrenciesList: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle(Constants.Titles.showAllExchangedCurrenciesListTitle, for: .normal)
    button.addTarget(self, action: #selector(showAllExchangedCurrencies), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.tintColor = .white
    button.backgroundColor = .systemIndigo
    button.layer.cornerRadius = 12
    button.clipsToBounds = true
    button.isHidden = true
    return button
  }()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    setupNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    addKeyboardObserver()
    passDataToPresenters()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    removeKeyboardObserver()
  }
  
  // MARK: - Setup Views
  
  private func addSubviews() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(middleView)
    middleView.addSubview(centralView)
    centralView.addSubview(activityIndicator)
    middleView.addSubview(firstCurrencyTextField)
    middleView.addSubview(secondCurrencyTextField)
    middleView.addSubview(fromCurrencySelectionButton)
    middleView.addSubview(swapButtons)
    middleView.addSubview(toCurrencySelectionButton)
    contentView.addSubview(showAllExchangedCurrenciesList)
  }
  
  private func setupNavigationBar() {
    navigationItem.backButtonTitle = Constants.Titles.navigationItemEmptyBackButtonTitle
    title = presenter.setNavigationBarTitle()
  }
  
  private func configureTextFields() {
    let textFields = [firstCurrencyTextField, secondCurrencyTextField]
    textFields.forEach {
      $0.setLeftPaddingPoints(10)
      $0.setRightPaddingPoints(10)
      $0.adjustsFontSizeToFitWidth = true
      $0.textAlignment = .center
      $0.textColor = .white
      $0.backgroundColor = .systemPink
      $0.keyboardType = .numberPad
      $0.layer.cornerRadius = 12
      $0.clearButtonMode = .whileEditing
      $0.smartDashesType = .no
      $0.minimumFontSize = 8
      $0.delegate = self
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.addTarget(self, action: #selector(textFieldsDidEditing), for: .editingChanged)
    }
  }
  
  private func configureSelectionButtons() {
    let buttons = [
      fromCurrencySelectionButton,
      toCurrencySelectionButton
    ]
    buttons.forEach {
      $0.tintColor = .white
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 12
      $0.backgroundColor = .systemIndigo
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.addTarget(self, action: #selector(selectCurrency), for: .touchUpInside)
    }
  }
  
  private func configureSwapButton() {
    let config = UIImage.SymbolConfiguration(
      pointSize: 40,
      weight: .regular,
      scale: .default)
    let image = UIImage(
      systemName: Constants.SystemName.swapButtonImage,
      withConfiguration: config)
    swapButtons.setImage(image, for: .normal)
    swapButtons.tintColor = .systemIndigo
    swapButtons.layer.cornerRadius = 12
    swapButtons.clipsToBounds = true
    swapButtons.translatesAutoresizingMaskIntoConstraints = false
    swapButtons.addTarget(
      self,
      action: #selector(swapCurrencies),
      for: .touchUpInside
    )
  }
  
  private func initialValues() {
    presenter.activeField = .firstTextField
    presenter.selectedButton = .fromButton
    presenter.fromCurrency = Constants.InitialValues.fromCurrencySelectionButtonInitialValue
    presenter.toCurrency = Constants.InitialValues.toCurrencySelectionButtonInitialValue
    presenter.amount = Constants.InitialValues.firstCurrencyTextFieldInitialValue
    presenter.valueForFirstField = Constants.InitialValues.firstCurrencyTextFieldInitialValue
    presenter.getValuesFromView(value: Constants.InitialValues.firstCurrencyTextFieldInitialValue)
  }
  
  private func setup() {
    view.backgroundColor = .systemBackground
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.hide()
    addSubviews()
    configureTextFields()
    configureSwapButton()
    configureSelectionButtons()
    setupNavigationBar()
    setupConstaints(0.0)
    hideKeyboardWhenTappedAround()
    initialValues()
  }
  
  // MARK: - Setup Constraints
  
  private func setupConstaints(_ duration: Double) {
    
    let contentViewHeight = contentView.heightAnchor.constraint(equalTo: view.heightAnchor)
    contentViewHeight.priority = UILayoutPriority(250)
    
    let scrollViewConstraints = [
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
    ]
    
    let contentViewConstraints = [
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
      contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
      contentViewHeight
    ]
    
    let middleViewConstraints = [
      middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
      middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
      middleView.heightAnchor.constraint(equalTo: middleView.widthAnchor),
      middleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      middleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ]
    
    let centralViewConstraints = [
      centralView.heightAnchor.constraint(equalToConstant: 10),
      centralView.widthAnchor.constraint(equalToConstant: 10),
      centralView.centerYAnchor.constraint(equalTo: middleView.centerYAnchor),
      centralView.centerXAnchor.constraint(equalTo: middleView.centerXAnchor)
    ]
    
    let fromButtonConstraints = [
      fromCurrencySelectionButton.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 50),
      fromCurrencySelectionButton.leftAnchor.constraint(equalTo: middleView.leftAnchor),
      fromCurrencySelectionButton.bottomAnchor.constraint(equalTo: swapButtons.topAnchor, constant: -5),
      fromCurrencySelectionButton.heightAnchor.constraint(equalTo: fromCurrencySelectionButton.widthAnchor)
    ]
    
    let swapButtonConstraints = [
      swapButtons.widthAnchor.constraint(equalToConstant: 40),
      swapButtons.heightAnchor.constraint(equalToConstant: 40),
      swapButtons.centerXAnchor.constraint(equalTo: fromCurrencySelectionButton.centerXAnchor),
      swapButtons.centerYAnchor.constraint(equalTo: centralView.centerYAnchor)
    ]
    
    let firstTextFieldConstraints = [
      firstCurrencyTextField.leftAnchor.constraint(equalTo: fromCurrencySelectionButton.rightAnchor, constant: 10),
      firstCurrencyTextField.rightAnchor.constraint(equalTo: middleView.rightAnchor),
      firstCurrencyTextField.heightAnchor.constraint(equalTo: fromCurrencySelectionButton.heightAnchor),
      firstCurrencyTextField.centerYAnchor.constraint(equalTo: fromCurrencySelectionButton.centerYAnchor)
    ]
    
    let toButtonConstraints = [
      toCurrencySelectionButton.topAnchor.constraint(equalTo: swapButtons.bottomAnchor, constant: 5),
      toCurrencySelectionButton.widthAnchor.constraint(equalTo: fromCurrencySelectionButton.widthAnchor),
      toCurrencySelectionButton.heightAnchor.constraint(equalTo: fromCurrencySelectionButton.heightAnchor),
      toCurrencySelectionButton.centerXAnchor.constraint(equalTo: fromCurrencySelectionButton.centerXAnchor)
    ]
    
    let secondTextFieldConstraints = [
      secondCurrencyTextField.centerXAnchor.constraint(equalTo: firstCurrencyTextField.centerXAnchor),
      secondCurrencyTextField.centerYAnchor.constraint(equalTo: toCurrencySelectionButton.centerYAnchor),
      secondCurrencyTextField.widthAnchor.constraint(equalTo: firstCurrencyTextField.widthAnchor),
      secondCurrencyTextField.heightAnchor.constraint(equalTo: firstCurrencyTextField.heightAnchor)
    ]
    
    let showAllCurrenciesModalConstraints = [
      showAllExchangedCurrenciesList.topAnchor.constraint(equalTo: middleView.bottomAnchor, constant: 10),
      showAllExchangedCurrenciesList.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 50),
      showAllExchangedCurrenciesList.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50),
      showAllExchangedCurrenciesList.heightAnchor.constraint(equalToConstant: 60)
    ]
    
    view.clearConstraints()
    
    NSLayoutConstraint.activate(scrollViewConstraints)
    NSLayoutConstraint.activate(contentViewConstraints)
    NSLayoutConstraint.activate(middleViewConstraints)
    NSLayoutConstraint.activate(centralViewConstraints)
    NSLayoutConstraint.activate(fromButtonConstraints)
    NSLayoutConstraint.activate(swapButtonConstraints)
    NSLayoutConstraint.activate(firstTextFieldConstraints)
    NSLayoutConstraint.activate(toButtonConstraints)
    NSLayoutConstraint.activate(secondTextFieldConstraints)
    NSLayoutConstraint.activate(showAllCurrenciesModalConstraints)
    
    UIView.animate(withDuration: duration) {
      self.view.layoutIfNeeded()
    }
  }
  
  private func changeMiddleViewFrame() {
    let screen = UIScreen.main.bounds.size.height / 2.7
    
    let constraintsWithPresentedModalView = [
      middleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
      middleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
      middleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
      middleView.heightAnchor.constraint(equalToConstant: screen)
    ]
    
    animateView(view: showAllExchangedCurrenciesList, hidden: true)
    
    NSLayoutConstraint.activate(constraintsWithPresentedModalView)
    
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  // MARK: - Actions
  
  private func passDataToPresenters() {
    if let currencyDidSelected {
      presenter.updateSelectedCurrency(currencyDidSelected)
      
      if presenter.selectedButton == .fromButton {
        animateView(view: showAllExchangedCurrenciesList, hidden: false)
        baseCurrencyDelegate?.sendBaseCurrency(currencyDidSelected)
      }
    }
  }
  
  @objc
  private func showAllExchangedCurrencies() {
    if presenter.selectedButton == .fromButton {
      guard let currencyDidSelected else { return }
      changeMiddleViewFrame()
      presenter.showModalWithAllExchangedCurrencies()
      onShowButtonAction?()
      baseCurrencyDelegate?.sendBaseCurrency(currencyDidSelected)
    }
  }
  
  @objc
  private func selectCurrency(_ sender: UIButton) {
    let selectedButton: SelectedButtonCondition = sender ==
    fromCurrencySelectionButton ? .fromButton : .toButton
    
    switch selectedButton {
    case .fromButton:
      presenter.selectedButton = .fromButton
    case .toButton:
      presenter.selectedButton = .toButton
    }
    
    presenter.selectNewCurrency()
  }
  
  @objc
  private func swapCurrencies() {
    presenter.swapCurrenciesButtons()
  }
  
  @objc
  private func textFieldsDidEditing(_ textField: UITextField) {
    let activeField: ActiveTextField = textField == firstCurrencyTextField
    ? .firstTextField
    : .secondTextField
    presenter.activeField = activeField
    
    if let amountString = textField.text?.currencyInputFormatting() {
      textField.text = amountString
      presenter.getValuesFromView(value: amountString)
    }
  }
  
  private func animateView(view: UIView, hidden: Bool) {
    UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
      view.isHidden = hidden
    })
  }
}

  // MARK: - Extension UITextFieldDelegate

extension ExchangeViewController: UITextFieldDelegate {
 func textFieldShouldClear(_ textField: UITextField) -> Bool {
   presenter.clearValues()
   return false
 }
}

  // MARK: - Extension Keyboard Methods

extension ExchangeViewController {
  
  private func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissKeyboard)
    )
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc
  private func dismissKeyboard() {
    view.endEditing(true)
  }
}

  // MARK: - Extension Exchange View Protocol

extension ExchangeViewController: ExchangeViewProtocol {
  
 func presentUpdatedViews(_ field: ActiveTextField) {
   fromCurrencySelectionButton.setTitle(
     presenter.fromCurrency,
     for: .normal)
   toCurrencySelectionButton.setTitle(
     presenter.toCurrency,
     for: .normal)
   
   switch field {
   case .firstTextField:
     secondCurrencyTextField.text = presenter.valueForSecondField
   case .secondTextField:
     firstCurrencyTextField.text = presenter.valueForFirstField
   }
 }
 
 func presentIndicator(isShow: Bool) {
   switch isShow {
   case true:
     activityIndicator.show()
   case false:
     activityIndicator.hide()
   }
 }
  
 func onFailure(error: Error) {
   self.showAlert(
    withTitle: Constants.Errors.errorTitle,
    withMessage: error.localizedDescription
   )
 }
}

  // MARK: - Extension Delegate Get Selected Currency From Currencies List

extension ExchangeViewController: ExchangeViewDelegate {
 func sendSelectedCurrency(_ currency: String) {
   currencyDidSelected = currency
 }
}
 
// MARK: - Live Preview

//#if DEBUG
//import SwiftUI
//
//struct HomeViewController_Preview: PreviewProvider {
//    static var previews: some View = Preview(
//        for: ExchangeViewController()
//    )
//}
//#endif
