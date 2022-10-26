//
//  Router.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import UIKit
 
protocol RouterProtocol {
  func initialViewController()
  func showCurrenciesList(isModal: Bool)
  func showAllExchangedCurrecniesList()
  func popToRootViewController()
}
 
final class Router: RouterProtocol {
   
  var navigationController: UINavigationController!
  var assemblyBuilder: AssemblyBuilderProtocol!
   
  var exchangeScreenView: ExchangeViewController?
  weak var currenciesListView: CurrenciesListViewController?
  weak var allExchangedCurrencyView: AllExchangedCurrenciesViewController?
  
  init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol) {
    self.navigationController = navigationController
    self.assemblyBuilder = assemblyBuilder
  }
  
  func initialViewController() {
    let exchangeVC = assemblyBuilder.createExchangeModule(with: self)
    exchangeScreenView = exchangeVC
    navigationController.viewControllers = [exchangeVC]
  }
  
  func showCurrenciesList(isModal: Bool) {
    let currenciesVC = assemblyBuilder.createCurrenciesListModule(with: self)
    currenciesListView = currenciesVC
    
    guard let currenciesListView else { return }
    currenciesListView.exchangeViewDelegate = exchangeScreenView
    navigationController.pushViewController(currenciesVC, animated: true)
  }
  
  func showAllExchangedCurrecniesList() {
    let allExchangedCurrencyVC = assemblyBuilder.createExchangedAllCurrencies(with: self)
    allExchangedCurrencyView = allExchangedCurrencyVC
    
    guard let exchangeScreenView else { return }
    exchangeScreenView.baseCurrencyDelegate = allExchangedCurrencyView
    let targetVC = UINavigationController(rootViewController: allExchangedCurrencyVC)
    
    if #available(iOS 15.0, *) {
      if let sheet = targetVC.sheetPresentationController {
        sheet.detents = [.medium(), .large()]
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersGrabberVisible = true
        sheet.prefersEdgeAttachedInCompactHeight = true
        ///sheet.largestUndimmedDetentIdentifier = .medium
        ///sheet.preferredCornerRadius = 50
      }
      navigationController.present(targetVC, animated: true)
    }
  }
  
  func popToRootViewController() {
    navigationController.popToRootViewController(animated: true)
  }
} 
