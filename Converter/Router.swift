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
    func showCurrenciesList(currency: ExchangeCurrenciesData?)
    func popToRoot()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
     
    init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController {
            guard let echangeViewController = assemblyBuilder?.createExchangeModule(router: self) else { return }
            navigationController.viewControllers = [echangeViewController]
        }
    }
    
    func showCurrenciesList(currency: ExchangeCurrenciesData?) {
        if let navigationController {
            guard let currenciesVC = assemblyBuilder?.createCurrenciesListModule(currency: currency, router: self) else { return }
            navigationController.pushViewController(currenciesVC, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
