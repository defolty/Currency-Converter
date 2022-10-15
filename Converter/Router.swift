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
  func changeExchangeElements(with text: String)
  func popToRoot()
}

class Router: RouterProtocol {
  
  var navigationController: UINavigationController?
  var assemblyBuilder: AssemblyBuilderProtocol?
  private var exchangeScreen: ExchangeScreenView?
  
  init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol) {
    self.navigationController = navigationController
    self.assemblyBuilder = assemblyBuilder
  }
  
  func initialViewController() { 
    if let navigationController {
      guard let exchangeVC = assemblyBuilder?.createExchangeModule(router: self) else { return }
      exchangeScreen = exchangeVC
      navigationController.viewControllers = [exchangeVC]
    }
  }
  
  func showCurrenciesList() { 
    if let navigationController {
      guard let currenciesVC = assemblyBuilder?.createCurrenciesListModule(router: self) else { return }
      let targetVC = UINavigationController(rootViewController: currenciesVC)
      navigationController.present(targetVC, animated: true)
    }
  }
  
  func changeExchangeElements(with text: String) {
    print("changeExchangeElements")
    guard let exchangeScreen else { return }
    guard let field = exchangeScreen.presenter.activeField else { return }
    switch field {
    case .firstTextField:
      exchangeScreen.presenter.fromCurrency = text
    case .secondTextField:
      exchangeScreen.presenter.toCurrency = text
    }
  }
  
  func popToRoot() {
    if let navigationController {
      //navigationController.popToRootViewController(animated: true)
      navigationController.dismiss(animated: true)
    }
  }
} 
