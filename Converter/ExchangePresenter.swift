//
//  ExchangePresenter.swift
//  Converter
//
//  Created by Nikita Nesporov on 06.10.2022.
//

import Foundation

enum SelectedButtonCondition {
  case fromButton, toButton
}

enum ActiveTextField {
  case firstTextField, secondTextField
}

protocol ExchangeViewProtocol: AnyObject {
  func showIndicator(show: Bool)
  func updateViews(field: ActiveTextField)
  func failure(error: Error)
}

protocol ExchangeViewPresenterProtocol: AnyObject {
  init(view: ExchangeViewProtocol,
       networkService: NetworkServiceProtocol,
       router: RouterProtocol?
  )
  func exchangeCurrencies(fromValue: String, toValue: String)
  func getValuesFromView(field: ActiveTextField, value: String)
  func setValues(rateForAmount: String, activeField: ActiveTextField)
  func showNumbersToUser(numbers: String) -> String
  func updateSelectedCurrency(currency: String)
  func tapOnButton()
  
  var selectedButton: SelectedButtonCondition? { get set }
  var activeField: ActiveTextField? { get set }
  var exchangeModel: ExchangeCurrenciesData? { get set }
  
  var fromCurrency: String? { get set }
  var toCurrency: String? { get set } 
  var valueForFirstField: String? { get set }
  var valueForSecondField: String? { get set }
  var amount: String? { get set }
}

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
    guard let selectedButton, let amount, let activeField else {
      return
    }
     
    switch selectedButton {
    case .fromButton:
      fromCurrency = currency
    case .toButton:
      toCurrency = currency
    }
     
    getValuesFromView(field: activeField, value: amount)
  }
  
  func getValuesFromView(field: ActiveTextField, value: String) {
    guard let fromCurrency, let toCurrency else { return }
    let safeValue = value.replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespaces)
    
    amount = safeValue
    activeField = field
    
    switch field {
    case .firstTextField:
      exchangeCurrencies(fromValue: fromCurrency, toValue: toCurrency)
    case .secondTextField:
      exchangeCurrencies(fromValue: toCurrency, toValue: fromCurrency)
    }
  }
  
  func exchangeCurrencies(fromValue: String, toValue: String) {
    guard let amount else { return }
    view?.showIndicator(show: true)
    networkService.exchangeCurrencies(fromValue: fromValue, toValue: toValue, currentAmount: amount) { [weak self] result in
      guard let self else { return }
      
      DispatchQueue.main.async { /// After(deadline: .now() + 0.275)
        switch result {
        case .success(let model):
          self.exchangeModel = model
          guard let rateForAmount = model?.rates?.first?.value.rateForAmount else { return }
          self.setValues(
            rateForAmount: rateForAmount,
            activeField: self.activeField!
          )
        case .failure(let error):
          self.view?.failure(error: error)
        }
      }
    }
  }
  
  func setValues(rateForAmount: String, activeField: ActiveTextField) {
    let rateForAmountAsDouble = Double(rateForAmount)
    
    switch activeField {
    case .firstTextField:
      valueForSecondField = rateForAmountAsDouble?.fractionDigits(min: 0, max: 2, roundingMode: .down)
    case .secondTextField:
      valueForFirstField = rateForAmountAsDouble?.fractionDigits(min: 0, max: 2, roundingMode: .down)
    }
    
    view?.showIndicator(show: false)
    view?.updateViews(field: activeField)
  }
  
  func showNumbersToUser(numbers: String) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.currencySymbol = ""
    // currencyFormatter.locale = Locale.current
    
    let numbersToDouble = Double(numbers)
    guard let numbersToDouble else { return "n/a" }
    let currencyString = currencyFormatter.string(from: NSNumber(value: numbersToDouble))
    guard let currencyString else { return "n/a" }
    return currencyString
  }
  
  func tapOnButton() {
      router?.showCurrenciesList()
  }
}
