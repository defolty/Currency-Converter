//
//  CurrenciesListViewPresenter.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import Foundation

  // MARK: - Presenter Protocol

protocol CurrenciesListViewPresenterProtocol {
   
  var currenciesList: [String]? { get set }
  var filteredList: [String]? { get set }
  var isFiltered: Bool { get set }
   
  func getCurrenciesList()
  func numberOfRows() -> Int
   
  func filterList(by text: String, state: Bool)
  func popToRootViewController()
}

  // MARK: - Currencies List Presenter

final class CurrenciesListPresenter: CurrenciesListViewPresenterProtocol {
   
  weak var view: CurrenciesListViewProtocol!
  private let networkService: NetworkServiceProtocol!
  private var router: RouterProtocol!
  
  var currenciesList: [String]?
  var filteredList: [String]?
  var isFiltered = false
   
  init(view: CurrenciesListViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?) {
    self.view = view
    self.networkService = networkService
    self.router = router
    getCurrenciesList()
  }
  
  // MARK: - Methods
  
  func numberOfRows() -> Int {
    isFiltered ? filteredList?.count ?? 0 : currenciesList?.count ?? 0
  }
  
  func filterList(by text: String, state: Bool) {
    isFiltered = state
    guard let currenciesList else { return }
    filteredList = currenciesList.filter { $0.lowercased().contains(text.lowercased()) }
  }
  
  func getCurrenciesList() {
    networkService.getCurrenciesList { [weak self] result in
      guard let self else { return }
      
      switch result {
      case .success(let list):
        self.currenciesList = list?.currencies.map { $0.key }.sorted()
        self.view?.onSuccess()
      case .failure(let error):
        self.view?.onFailure(error: error)
      }
    }
  }
  
  func popToRootViewController() {
    router?.popToRootViewController()
  }
} 


