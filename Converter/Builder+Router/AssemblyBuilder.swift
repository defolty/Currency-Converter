//
//  AssemblyBuilder.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
  func createExchangeModule(with router: RouterProtocol) -> ExchangeViewController
  func createCurrenciesListModule(with router: RouterProtocol) -> CurrenciesListViewController
  func createExchangedAllCurrencies(with router: RouterProtocol) -> AllExchangedCurrenciesViewController
}

final class AssemblyBuilder: AssemblyBuilderProtocol {
  
  func createExchangeModule(with router: RouterProtocol) -> ExchangeViewController {
    let view = ExchangeViewController()
    let networkService = NetworkService()
    let presenter = ExchangePresenter(
      view: view,
      networkService: networkService,
      router: router
    )
    view.presenter = presenter
    return view
  }
  
  func createCurrenciesListModule(with router: RouterProtocol) -> CurrenciesListViewController {
    let view = CurrenciesListViewController()
    let networkService = NetworkService()
    let presenter = CurrenciesListPresenter(
      view: view,
      networkService: networkService,
      router: router
    )
    view.presenter = presenter
    return view
  }
  
  func createExchangedAllCurrencies(with router: RouterProtocol) -> AllExchangedCurrenciesViewController { 
    let view = AllExchangedCurrenciesViewController()
    let networkService = NetworkService()
    let presenter = AllExchangedCurrenciesPresenter(
      view: view,
      networkService: networkService,
      router: router
    )
    view.presenter = presenter
    return view
  }
}
