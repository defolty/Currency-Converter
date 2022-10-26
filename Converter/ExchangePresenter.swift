//
//  ExchangePresenter.swift
//  Converter
//
//  Created by Nikita Nesporov on 06.10.2022.
//

import UIKit

  // MARK: - Condition Enums

enum SelectedButtonCondition {
  case fromButton, toButton
}

enum ActiveTextField {
  case firstTextField, secondTextField
}
 
  // MARK: - Presenter Protocol
 
protocol ExchangeViewPresenterProtocol {
  var activeField: ActiveTextField? { get set }
  var selectedButton: SelectedButtonCondition? { get set }
  var exchangeModel: ExchangeCurrenciesData? { get set }
   
  var amount: String? { get set }
  var toCurrency: String? { get set }
  var fromCurrency: String? { get set }
  var valueForFirstField: String? { get set }
  var valueForSecondField: String? { get set }
  
  func clearValues()
  func swapCurrenciesButtons()
  func setValues(with rate: String)
  func selectNewCurrency(modal: Bool)
  func getValuesFromView(value: String)
  func setNavigationBarTitle() -> String
  func showModalWithAllExchangedCurrencies()
  func updateSelectedCurrency(_ currency: String)
  func exchangeCurrenciesValues(fromValue: String, toValue: String)
}

  // MARK: - Exchange Presenter

final class ExchangePresenter: ExchangeViewPresenterProtocol {
  weak var view: ExchangeViewProtocol!
  let router: RouterProtocol!
  let networkService: NetworkServiceProtocol!
  var exchangeModel: ExchangeCurrenciesData?
   
  var selectedButton: SelectedButtonCondition?
  var activeField: ActiveTextField?
   
  var fromCurrency: String?
  var toCurrency: String?
  var valueForFirstField: String?
  var valueForSecondField: String?
  var amount: String?
   
  init(view: ExchangeViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?) {
    self.view = view
    self.networkService = networkService
    self.router = router
  }
    
  // MARK: - Methods
  
  func updateSelectedCurrency(_ currency: String) {
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

  func swapCurrenciesButtons() {
    guard let amount else { return }
    swap(&fromCurrency, &toCurrency)
    getValuesFromView(value: amount)
  }
  
  func getValuesFromView(value: String) {
    guard let fromCurrency, let toCurrency, let activeField else { return } 
    let safeValue = value.replacingOccurrences(of: " ", with: "")
     
    amount = safeValue
    
    switch activeField {
    case .firstTextField:
      exchangeCurrenciesValues(fromValue: fromCurrency, toValue: toCurrency)
    case .secondTextField:
      exchangeCurrenciesValues(fromValue: toCurrency, toValue: fromCurrency)
    }
  }
  
  func exchangeCurrenciesValues(fromValue: String, toValue: String) {
    guard let amount else { return }
    view?.presentIndicator(isShow: true)
    
    networkService.exchangeCurrencies(fromValue: fromValue, toValue: toValue, currentAmount: amount) { [weak self] result in
      guard let self else { return }
       
      switch result {
      case .success(let model):
        self.exchangeModel = model
        guard let rateForAmount = model?.rates?.first?.value.rateForAmount else { return }
        self.setValues(
          with: rateForAmount
        )
      case .failure(let error):
        self.view?.onFailure(error: error)
      }
    }
  }
   
  func setValues(with rate: String) {  
    let rateForAmountAsDouble = Double(rate)
    
    guard let activeField else { return }
    switch activeField {
    case .firstTextField:
      valueForSecondField = rateForAmountAsDouble?.fractionDigits(min: 2, max: 2, roundingMode: .halfEven)
    case .secondTextField:
      valueForFirstField = rateForAmountAsDouble?.fractionDigits(min: 2, max: 2, roundingMode: .halfEven) 
    }
    
    view?.presentIndicator(isShow: false)
    view?.presentUpdatedViews(activeField)
  }
  
  func clearValues() {
    valueForFirstField = ""
    valueForSecondField = ""
    
    view?.presentUpdatedViews(.firstTextField)
    view?.presentUpdatedViews(.secondTextField)
  }
  
  func setNavigationBarTitle() -> String {
    if UIDevice.current.orientation.isLandscape {
      return Constants.Titles.navigationItemEmptyBackButtonTitle
    } else {
      return Constants.Titles.navigationBarTitle
    }
  }
  
  func showModalWithAllExchangedCurrencies() {
    router?.showAllExchangedCurrecniesList()
  }
    
  func selectNewCurrency(modal: Bool) {
      router?.showCurrenciesList(isModal: modal)
  }
}
