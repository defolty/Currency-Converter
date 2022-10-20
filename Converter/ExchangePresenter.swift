//
//  ExchangePresenter.swift
//  Converter
//
//  Created by Nikita Nesporov on 06.10.2022.
//

import Foundation

  // MARK: - Enums

enum SelectedButtonCondition {
  case fromButton, toButton
}

enum ActiveTextField {
  case firstTextField, secondTextField
}

  // MARK: - View Protocol

protocol ExchangeViewProtocol: AnyObject {
  func presentIndicator(show: Bool)
  func presentUpdatedViews(field: ActiveTextField)
  func presentFailure(error: Error)
}

  // MARK: - Presenter Protocol

protocol ExchangeViewPresenterProtocol: AnyObject {
  init(view: ExchangeViewProtocol,
       networkService: NetworkServiceProtocol,
       router: RouterProtocol?
  )
  var selectedButton: SelectedButtonCondition? { get set }
  var activeField: ActiveTextField? { get set }
  var exchangeModel: ExchangeCurrenciesData? { get set }
  
  var fromCurrency: String? { get set }
  var toCurrency: String? { get set } 
  var valueForFirstField: String? { get set }
  var valueForSecondField: String? { get set }
  var amount: String? { get set }
  
  func updateSelectedCurrency(currency: String)
  func clearValues()
  func swapCurrenciesButtons()
  func getValuesFromView(value: String)
  func exchangeCurrencies(fromValue: String, toValue: String)
  func setValues(rateForAmount: String)
  func selectNewCurrency()
}

  // MARK: - Exchange Presenter

final class ExchangePresenter: ExchangeViewPresenterProtocol {
  let view: ExchangeViewProtocol?
  let router: RouterProtocol?
  let networkService: NetworkServiceProtocol!
  var exchangeModel: ExchangeCurrenciesData?
   
  var selectedButton: SelectedButtonCondition?
  var activeField: ActiveTextField?
  
  var fromCurrency: String?
  var toCurrency: String?
  var valueForFirstField: String?
  var valueForSecondField: String?
  var amount: String?
  
  required init(view: ExchangeViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?) {
    self.view = view
    self.networkService = networkService
    self.router = router
  }
   
  func updateSelectedCurrency(currency: String) {
    guard let selectedButton, let amount else { return }
     
    switch selectedButton {
    case .fromButton:
      fromCurrency = currency
      activeField = .firstTextField
    case .toButton:
      toCurrency = currency
      activeField = .secondTextField
    }
    
    getValuesFromView(value: amount)
  }
  
  // MARK: - Methods
  
  func swapCurrenciesButtons() {
    let tempFromButton = fromCurrency
    let tempToButton = toCurrency
    fromCurrency = tempToButton
    toCurrency = tempFromButton
    guard let amount else { return }
    getValuesFromView(value: amount)
  }
  
  func getValuesFromView(value: String) {
    guard let fromCurrency, let toCurrency, let activeField else { return } 
    let safeValue = value.replacingOccurrences(of: " ", with: "")
     
    amount = safeValue
    
    switch activeField {
    case .firstTextField:
      exchangeCurrencies(fromValue: fromCurrency, toValue: toCurrency)
    case .secondTextField:
      exchangeCurrencies(fromValue: toCurrency, toValue: fromCurrency)
    }
  }
  
  func exchangeCurrencies(fromValue: String, toValue: String) {
    guard let amount else { return }
    view?.presentIndicator(show: true)
    networkService.exchangeCurrencies(fromValue: fromValue, toValue: toValue, currentAmount: amount) { [weak self] result in
      guard let self else { return }
      
      DispatchQueue.main.async { /// After(deadline: .now() + 0.375)
        switch result {
        case .success(let model):
          self.exchangeModel = model
          guard let rateForAmount = model?.rates?.first?.value.rateForAmount else { return }
          self.setValues(
            rateForAmount: rateForAmount
          )
        case .failure(let error):
          self.view?.presentFailure(error: error)
        }
      }
    }
  }
   
  func setValues(rateForAmount: String) {  
    let rateForAmountAsDouble = Double(rateForAmount)
    
    guard let activeField else { return }
    switch activeField {
    case .firstTextField:
      valueForSecondField = rateForAmountAsDouble?.fractionDigits(min: 2, max: 2, roundingMode: .halfEven)
    case .secondTextField:
      valueForFirstField = rateForAmountAsDouble?.fractionDigits(min: 2, max: 2, roundingMode: .halfEven) 
    }
    
    view?.presentIndicator(show: false)
    view?.presentUpdatedViews(field: activeField)
  }
  
  func clearValues() {
    valueForFirstField = ""
    valueForSecondField = ""
    
    view?.presentUpdatedViews(field: .firstTextField)
    view?.presentUpdatedViews(field: .secondTextField)
  }
    
  func selectNewCurrency() {
      router?.showCurrenciesList()
  }
}
