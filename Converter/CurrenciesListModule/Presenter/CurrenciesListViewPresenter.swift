//
//  CurrenciesListViewPresenter.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import Foundation

// что должен уметь делать presenter для list view:
// - получать список валют - ок
// - получать выбранную кнопку
// - отправлять выбранную валюту в exchange view
 
protocol CurrenciesListViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}
  
protocol CurrenciesListViewPresenterProtocol: AnyObject {
    init(view: CurrenciesListViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?)
    func getCurrenciesList()
    func popToRoot()
    var currenciesList: [String]? { get set } 
}
 
class CurrenciesListPresenter: CurrenciesListViewPresenterProtocol {
    
    weak var view: CurrenciesListViewProtocol?
    let networkService: NetworkServiceProtocol!
    var router: RouterProtocol?
    var currenciesList: [String]?
     
    required init(view: CurrenciesListViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getCurrenciesList()
    }
    
    func popToRoot() {
        router?.popToRoot()
    }
    
    func getCurrenciesList() {
        networkService.getCurrenciesList { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self.currenciesList = list?.currencies.map{ $0.key }.sorted()
                    self.view?.success() 
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
} 
 
