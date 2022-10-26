//
//  ExchangeAllCurrenciesListPresenter.swift
//  Converter
//
//  Created by Nikita Nesporov on 21.10.2022.
//

import Foundation

// MARK: - Presenter Protocol

protocol AllExchangedCurrenciesPresenterProtocol {
  
  var currenciesList: [String]? { get set }
  var currinciesWithRate: [String: String] { get set }
  
  var keysArraySorted: [String]? { get set }
  var valuesArraySorted: [String]? { get set }
  
  var fromCurrency: String? { get set }
  
  var filteredList: [String]? { get set }
  var isFiltered: Bool { get set }
  
  func numberOfRows() -> Int
  func getCurrenciesList()
  func exchangeAllCurrencies()
  func getCellText(indexPath: IndexPath) -> String
  func getNavigationBarTitle() -> String
  func filterList(text: String, state: Bool)
}

// MARK: - Exchange All Currencies Presenter

final class AllExchangedCurrenciesPresenter: AllExchangedCurrenciesPresenterProtocol {
  
  weak var view: AllExchangedCurrenciesViewProtocol!
  private let networkService: NetworkServiceProtocol!
  private var router: RouterProtocol!
  
  var currenciesList: [String]?
  var currinciesWithRate: [String: String] = [:]
  
  var keysArraySorted: [String]?
  var valuesArraySorted: [String]?
  
  var fromCurrency: String?
  
  var filteredList: [String]?
  var isFiltered = false
  
  init(view: AllExchangedCurrenciesViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?) {
    self.view = view
    self.networkService = networkService
    self.router = router 
  }
  
  // MARK: - Methods
  
  func numberOfRows() -> Int {
    isFiltered ? filteredList?.count ?? 0 : keysArraySorted?.count ?? 0
  }
  
  func filterList(text: String, state: Bool) {
    isFiltered = state
    guard let keysArraySorted else { return }
    filteredList = keysArraySorted.filter { $0.lowercased().contains(text.lowercased()) }
  }
  
  func getCurrenciesList() {
    networkService.getCurrenciesList { [weak self] result in
      guard let self else { return }
      
      switch result {
      case .success(let list):
        self.currenciesList = list?.currencies.map{ $0.key }.sorted()
        self.exchangeAllCurrencies()
      case .failure(let error):
        self.view?.onFailure(error: error)
      }
    }
  }
  
  func exchangeAllCurrencies() {
    guard let currenciesList else { return }
    
    for currency in currenciesList {
      guard let fromCurrency else { return }
      networkService.exchangeAllCurrencies(fromValue: fromCurrency, toValue: currency) { [weak self] result in
        guard let self else { return }
        
        switch result {
        case .success(let model):
          guard let valute = model?.rates?.first?.key else { return }
          guard let rate = model?.rates?.first?.value.rate else { return }
          self.setDict(key: valute, value: rate)
        case .failure(let error):
          self.view?.onFailure(error: error)
        }
      }
    }
  }
  
  func setDict(key: String, value: String) {
    currinciesWithRate[key] = value
    let sortedCurrenciesWithRate = currinciesWithRate.sorted(by: { $0.key < $1.key })
    
    keysArraySorted = Array(sortedCurrenciesWithRate.map({ $0.key }))
    valuesArraySorted = Array(sortedCurrenciesWithRate.map({ $0.value }))
    
    view?.onSuccess()
  }
  
  func getFilteredCellText(text: String, state: Bool, indexPath: IndexPath) -> String {
    guard let keysArraySorted, let fromCurrency, let valuesArraySorted else { return Constants.Errors.errorGetCellText }
    isFiltered = state
    filteredList = keysArraySorted.filter { $0.lowercased().contains(text.lowercased()) }
    let cellText = "1 \(fromCurrency) = \(valuesArraySorted[indexPath.row]) \(keysArraySorted[indexPath.row])"
    return cellText
  }
  
  func getCellText(indexPath: IndexPath) -> String {
    guard let keysArraySorted, let fromCurrency, let valuesArraySorted else { return Constants.Errors.errorGetCellText }
    let cellText = "1 \(fromCurrency) = \(valuesArraySorted[indexPath.row]) \(keysArraySorted[indexPath.row])"
    return cellText
  }
  
  func getNavigationBarTitle() -> String {
    guard let fromCurrency else { return Constants.Errors.errorNavBarTitle }
    let navBarTitle = "\(fromCurrency) \(Constants.Titles.allExchangedCurrenciesNavBarTitle)"
    return navBarTitle
  }
}



