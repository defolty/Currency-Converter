//
//  CurrenciesListViewPresenter.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import Foundation

protocol CurrenciesListViewProtocol: AnyObject {
  func success()
  func failure(error: Error)
}

protocol CurrenciesListViewPresenterProtocol: AnyObject {
  init(view: CurrenciesListViewProtocol,
       networkService: NetworkServiceProtocol,
       router: RouterProtocol?
  )
  var currenciesList: [String]? { get set }
  var filteredList: [String]? { get set }
  var isFiltered: Bool { get set }
  
  func getCurrenciesList()
  func numberOfRows() -> Int
  func filterList(text: String, state: Bool)
  func popToRoot()
}

final class CurrenciesListPresenter: CurrenciesListViewPresenterProtocol {
  weak var view: CurrenciesListViewProtocol?
  let networkService: NetworkServiceProtocol!
  var router: RouterProtocol?
  
  var currenciesList: [String]?
  var filteredList: [String]?
  var isFiltered = false
  
  required init(view: CurrenciesListViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?) {
    self.view = view
    self.networkService = networkService
    self.router = router
    getCurrenciesList()
  }
  
  func numberOfRows() -> Int {
    if isFiltered {
      return filteredList?.count ?? 0
    } else {
      return currenciesList?.count ?? 0
    }
  }
  
  func filterList(text: String, state: Bool) {
    isFiltered = state
    guard let currenciesList else { return }
    filteredList = currenciesList.filter { $0.lowercased().contains(text.lowercased()) }
  }
   
  func getCurrenciesList() {
    networkService.getCurrenciesList { [weak self] result in
      guard let self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success(let list):
          self.currenciesList = list?.currencies.map{ $0.key }.sorted()
          self.view?.success()
        case .failure(let error):
          self.view?.failure(error: error)
        }
      }
    }
  }
  
  func popToRoot() {
    router?.popToRoot()
  }
} 

