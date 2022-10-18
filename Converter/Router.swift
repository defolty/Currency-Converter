//
//  Router.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import UIKit

protocol RouterMain {
  var navigationController: UINavigationController? { get set }
  var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
  func initialViewController()
  func showCurrenciesList()
  func popToRoot()
}

class Router: RouterProtocol {
  
  var navigationController: UINavigationController?
  var assemblyBuilder: AssemblyBuilderProtocol?
  var exchangeScreenView: ExchangeScreenView?
  var currenciesListView: CurrenciesListView?
  
  init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol) {
    self.navigationController = navigationController
    self.assemblyBuilder = assemblyBuilder
  }
  
  func initialViewController() { 
    if let navigationController {
      guard let exchangeVC = assemblyBuilder?.createExchangeModule(router: self) else { return }
      exchangeScreenView = exchangeVC
      navigationController.viewControllers = [exchangeVC]
    }
  }
  
  func showCurrenciesList() { 
    if let navigationController {
      guard let currenciesVC = assemblyBuilder?.createCurrenciesListModule(router: self) else { return }
      currenciesListView = currenciesVC
      guard let currenciesListView else { return }
      currenciesListView.sendCurrencyDelegate = exchangeScreenView
      navigationController.pushViewController(currenciesVC, animated: true)
      
      ///# for `modal view`
      ///# let targetVC = UINavigationController(rootViewController: currenciesVC)
      ///# navigationController.present(targetVC, animated: true)
    }
  }
   
  func popToRoot() {
    if let navigationController {
      navigationController.popToRootViewController(animated: true)
    }
  }
} 
