//
//  ModuleBuilder.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import UIKit

protocol AssemblyBuilderProtocol { 
  func createExchangeModule(router: RouterProtocol) -> ExchangeScreenView
  func createCurrenciesListModule(router: RouterProtocol) -> CurrenciesListView
}

final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
  
  func createExchangeModule(router: RouterProtocol) -> ExchangeScreenView {
    let view = ExchangeScreenView()
    let networkService = NetworkService()
    let presenter = ExchangePresenter(
      view: view,
      networkService: networkService,
      router: router
    )
    view.presenter = presenter
    return view
  }
  
  func createCurrenciesListModule(router: RouterProtocol) -> CurrenciesListView {
    let view = CurrenciesListView()
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
