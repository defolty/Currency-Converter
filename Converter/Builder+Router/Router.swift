//
//  Router.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import UIKit
 
protocol RouterProtocol {
  func showExchangeViewController()
  func showCurrenciesList()
  func showAllExchangedCurrenciesList()
  func resetExchangeViewConstraints()
  func popToRootViewController()
}
 
final class Router: RouterProtocol {
  
  var assemblyBuilder: AssemblyBuilderProtocol!
  var navigationController: UINavigationController!
   
  var exchangeScreenView: ExchangeViewController?
  weak var currenciesListView: CurrenciesListViewController?
  weak var allExchangedCurrencyView: AllExchangedCurrenciesViewController?
  
  init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol) {
    self.navigationController = navigationController
    self.assemblyBuilder = assemblyBuilder
  }
  
  // MARK: - Initial ViewController
  
  func showExchangeViewController() {
    let exchangeVC = assemblyBuilder.createExchangeModule(with: self)
    exchangeScreenView = exchangeVC
    
    navigationController.setViewControllers([exchangeVC], animated: true)
    //navigationController.viewControllers = [exchangeVC]
  }
  
  // MARK: - Currencies List
  
  func showCurrenciesList() {
    let currenciesVC = assemblyBuilder.createCurrenciesListModule(with: self)
    currenciesListView = currenciesVC
    
    guard let currenciesListView else { return }
    currenciesListView.exchangeViewDelegate = exchangeScreenView
    navigationController.pushViewController(currenciesVC, animated: true)
  }
  
  // MARK: - All Exchanged Currencies List
  
  func showAllExchangedCurrenciesList() {
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
        sheet.largestUndimmedDetentIdentifier = .medium
      }
      
      navigationController.present(targetVC, animated: true)
    }
  }
  
  func resetExchangeViewConstraints() {
    guard let exchangeScreenView else { return }
    exchangeScreenView.resetConstraintsIfNeeded = true
  }
  
  func popToRootViewController() {
    navigationController.popToRootViewController(animated: true)
  }
} 
