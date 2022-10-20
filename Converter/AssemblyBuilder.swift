//
//  AssemblyBuilder.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import UIKit

protocol AssemblyBuilderProtocol { 
  func createExchangeModule(router: RouterProtocol) -> ExchangeViewController
  func createCurrenciesListModule(router: RouterProtocol) -> CurrenciesListViewController
}

final class AssemblyBuilder: AssemblyBuilderProtocol {
  
  func createExchangeModule(router: RouterProtocol) -> ExchangeViewController {
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
  
  func createCurrenciesListModule(router: RouterProtocol) -> CurrenciesListViewController {
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
}
