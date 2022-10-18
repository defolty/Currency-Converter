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
  var selectedButton: SelectedButtonCondition? { get set }
  var activeField: ActiveTextField? { get set }
  var exchangeModel: ExchangeCurrenciesData? { get set }
  
  var fromCurrency: String? { get set }
  var toCurrency: String? { get set } 
  var valueForFirstField: String? { get set }
  var valueForSecondField: String? { get set }
  var amount: String? { get set }
  
  func updateSelectedCurrency(currency: String)
  func swapButtons()
  func getValuesFromView(value: String)
  func exchangeCurrencies(fromValue: String, toValue: String)
  func setValues(rateForAmount: String)
  func showNumbersToUser(numbers: String) -> String
  func tapOnButton()
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
  
  func swapButtons() {
    let tempFromButton = fromCurrency
    let tempToButton = toCurrency
    fromCurrency = tempToButton
    toCurrency = tempFromButton
    guard let amount else { return }
    getValuesFromView(value: amount)
  }
  
  func getValuesFromView(value: String) {
    print("getValuesFromView value", "\(value)!")
    
    guard let fromCurrency, let toCurrency, let activeField else { return }
    
    let safeValue = value.replacingOccurrences(of: ",", with: "")
    print("getValuesFromView safeValue", safeValue)
     
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
    view?.showIndicator(show: true)
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
          self.view?.failure(error: error)
        }
      }
    }
  }
  
  func setValues(rateForAmount: String) {  
    let rateForAmountAsDouble = Double(rateForAmount)
    guard let activeField else { return }
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
    print("\n")
    print("showNumbersToUser")
    print("numbers", numbers)
    
    let safeNumbers = numbers.replacingOccurrences(of: ",", with: ".")
    print("safeNumbers", safeNumbers)
    
    let safeNumbersWithoutSpace = safeNumbers.replacingOccurrences(of: " ", with: "")
    print("safeNumbersWithoutSpace", safeNumbersWithoutSpace)
    
    if let numbersToDouble = Double(safeNumbersWithoutSpace) {
      
      let currencyString = numbersToDouble.fractionDigits(min: 0, max: 2)
      print("currencyString", currencyString)
      print("showNumbersToUser end", "\n")
      
      return currencyString
    }
    return "error"
  }
  
  func tapOnButton() {
      router?.showCurrenciesList()
  }
}
