//
//  ModuleBuilder.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createExchangeModule(router: RouterProtocol) -> UIViewController
    func createCurrenciesListModule(currency didSelected: ExchangeCurrenciesData?, router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createExchangeModule(router: RouterProtocol) -> UIViewController {
        let view = ExchangeScreenView()
        let networkService = NetworkService()
        let presenter = ExchangePresenter(view: view, model: <#T##ExchangeModel#>)
        view.presenter = presenter
        ///# + от такого способа это возможность подставить другой объект, например другой `vc` для тестов
        return view
    }
    
    func createDetailModule(comment: Comment?, router: RouterProtocol) -> UIViewController {
        let view = DetailView()
        let networkService = NetworkService()
        let presenter = DetailPresenter(view: view, networkService: networkService, router: router, comment: comment)
        view.presenter = presenter
        return view
    }
}
