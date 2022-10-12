//
//  ModuleBuilder.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import UIKit

protocol AssemblyBuilderProtocol { 
    func createExchangeModule(router: RouterProtocol) -> UIViewController
//    selectedButton: SelectedButtonCondition
    func createCurrenciesListModule(router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func createExchangeModule(router: RouterProtocol) -> UIViewController {
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
    
    func createCurrenciesListModule(router: RouterProtocol) -> UIViewController {
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
